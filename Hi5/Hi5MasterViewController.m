//
//  Hi5MasterViewController.m
//  Hi5
//
//  Created by Himanshu Tantia on 4/22/14.
//
//

#import <AudioToolbox/AudioToolbox.h>
#import "Hi5MasterViewController.h"
#import "Hi5CollectionView.h"
#import "Hi5CardCell.h"
#import "Hi5CardDeck.h"
#import "Hi5Card.h"

#define NUM_CARD_ROW 6

@interface Hi5MasterViewController ()  <UICollectionViewDataSource,
                                        Hi5CollectionViewDelegate,
                                        Hi5CardCellDelegate,
                                        UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet Hi5CollectionView *boardView;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeElapsedLabel;
@property (weak, nonatomic) IBOutlet UILabel *movesLabel;

@property (nonatomic, strong) NSMutableArray *cardArray;
@property (nonatomic, strong) Hi5CardDeck *deck;
@property (nonatomic, assign) NSUInteger numberOfMoves;
@property (nonatomic, strong) NSDate *totalTimeSinceStartOfGame;
@property (nonatomic, strong) NSTimer *totalTimeElapsedTimer;
@end

@implementation Hi5MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.deck = [Hi5CardDeck sharedInstance];
    
    [self.boardView.layer setBorderWidth:0.5];
    [self.boardView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"empty+0.jpg"]]];
    
    [self startNewGame];
}

-(void)startUpdatingTimeElapsedLabel
{
    self.totalTimeElapsedTimer =  [NSTimer timerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(timeElapsedFormatedString)
                                                        userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.totalTimeElapsedTimer
                              forMode:NSDefaultRunLoopMode];
}

-(void)stopUpdatingTimeElapsedLabel
{
    [self.totalTimeElapsedTimer invalidate];
}

- (NSString *)timeElapsedFormatedString
{
    if (self.totalTimeSinceStartOfGame == nil)
        return nil;
    
    NSInteger time = [[NSDate date] timeIntervalSinceDate:self.totalTimeSinceStartOfGame];
    NSString *timeleftStr = @"";
    if (time<0)
    {
        timeleftStr = @"Ended";
    }
    else if (time>60)
    {
        timeleftStr = [NSString stringWithFormat:@"%lum %lus",(long)time/60,(long)time%60];
    }
    else
    {
        timeleftStr = [NSString stringWithFormat:@"%lus",(long)time];
    }
    self.totalTimeElapsedLabel.text = timeleftStr;
    return timeleftStr;
}

- (NSMutableArray *)cardArray
{
    if (_cardArray==nil) {
        NSUInteger numRows = [self.deck count]/NUM_CARD_ROW;
        _cardArray = [NSMutableArray new];
        for (int i =0; i<numRows; i++) {
            NSRange r = NSMakeRange(i*NUM_CARD_ROW, NUM_CARD_ROW);
            NSIndexSet *is = [NSIndexSet indexSetWithIndexesInRange:r];
            __autoreleasing NSMutableArray *s1 = [NSMutableArray arrayWithArray:[[self.deck deck] objectsAtIndexes:is]];
            [_cardArray addObject:s1];
        }
    }
    return _cardArray;
}

- (IBAction)startNewGame
{
    self.movesLabel.text = @"0";
    self.totalTimeElapsedLabel.text = @"0s";
    self.numberOfMoves = 0;
    self.totalTimeSinceStartOfGame = nil;
    _cardArray.count>0?[self.cardArray removeAllObjects]:nil;
    self.cardArray = nil;
    [self.boardView resetEmptyCells];
    [self.deck shuffle];
    [self.boardView reloadData];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1 && buttonIndex == [alertView cancelButtonIndex]) {
        [self startNewGame];
    }
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.cardArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.cardArray objectAtIndex:section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Hi5CardCell *cell = [self.boardView dequeueReusableCellWithReuseIdentifier:[Hi5CardCell reuseIdentifier]
                                                                                 forIndexPath:indexPath];
    cell.delegate = self;
    cell.debugLabel.text = [NSString stringWithFormat:@"%lu",(long)[indexPath item]];
    cell.tag = indexPath.item+1;
    
    Hi5Card *c = [[self.cardArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
    [cell populateWithCard:c];
    if (c.rank == kCardRankEmpty) {
        [self.boardView addEmptyCells:cell];
    }
    if (indexPath.section==3&&indexPath.item==5) {
        [self.boardView adjustEmptyCells];
    }
    return cell;
}

-(void)didGameEndWithSuccess:(BOOL)success
{
    [self stopUpdatingTimeElapsedLabel];
    if (success) {
        [[self alertWithTitle:@"Yayyy" andMessage:@"Play Again? :D"] setTag:1];
    }else
        [[self alertWithTitle:@"Meh, Never Mind!!" andMessage:@"Try Again! :)"] setTag:1];
}

-(BOOL)shouldDragCell:(Hi5CardCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    return (cell.card.rank != kCardRankEmpty);
}

-(void)willSwapCellAtIndexPath:(NSIndexPath *)sourceIndexpath withCellAtIndexPath:(NSIndexPath *)targetIndexpath
{
    [self shouldSwapCellAtIndexPath:sourceIndexpath
                withCellAtIndexPath:targetIndexpath];
}

-(void)swapCellAtIndexPath:(NSIndexPath *)sourceIndexpath
       withCellAtIndexPath:(NSIndexPath *)targetIndexpath
{
    if(self.totalTimeSinceStartOfGame==nil) {
        self.totalTimeSinceStartOfGame = [NSDate date];
        [self startUpdatingTimeElapsedLabel];
    }
    
    Hi5CardCell *targetCell = (Hi5CardCell *)[self.boardView
                                              cellForItemAtIndexPath:targetIndexpath];
    [targetCell showBorder:NO];
    [self.boardView performBatchUpdates:^{
        [self.boardView moveItemAtIndexPath:sourceIndexpath
                                toIndexPath:targetIndexpath];
        [self.boardView moveItemAtIndexPath:targetIndexpath
                                toIndexPath:sourceIndexpath];
        Hi5Card *source = [[self.cardArray objectAtIndex:sourceIndexpath.section] objectAtIndex:sourceIndexpath.item];
        Hi5Card *target = [[self.cardArray objectAtIndex:targetIndexpath.section] objectAtIndex:targetIndexpath.item];
        [[self.cardArray objectAtIndex:sourceIndexpath.section] setObject:target atIndex:sourceIndexpath.item];
        [[self.cardArray objectAtIndex:targetIndexpath.section] setObject:source atIndex:targetIndexpath.item];
    } completion:^(BOOL finished) {
        [targetCell showBorder:YES];
        [self.boardView adjustEmptyCells];
        [self.boardView checkForGameCompletion];
        self.numberOfMoves++;
        self.movesLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.numberOfMoves];
    }];
}

-(void)shouldSwapCellAtIndexPath:(NSIndexPath *)sourceIndexpath
             withCellAtIndexPath:(NSIndexPath *)targetIndexpath
{
    Hi5CardCell *sourceCell = (Hi5CardCell *)[self.boardView cellForItemAtIndexPath:sourceIndexpath];
    Hi5CardCell *targetCell = (Hi5CardCell *)[self.boardView cellForItemAtIndexPath:targetIndexpath];
	//Checking if the selected card is valid. i.e. not empty card
	if(sourceCell.card.rank != kCardRankEmpty)
	{
		//Checking if the target card is valid. i.e. an empty card
		if(targetCell.card.rank == kCardRankEmpty)
		{
			//Checking if the selected card is an Ace card;
			if(sourceCell.card.rank == kCardRankLowest)
			{
				//Ace can only be placed in the first element of any row
				if(targetIndexpath.item == 0)
				{
					[self swapCellAtIndexPath:sourceIndexpath
                          withCellAtIndexPath:targetIndexpath];
				}
				else
				{
					[self didFailToSwapCardsWithError:@"An Ace can only occupy the First Coloumn"];
				}
			}
			else
			{
				if(targetIndexpath.item == 0)
				{
					[self didFailToSwapCardsWithError:@"You can only place an Ace here"];
				}
				else
				{
					Hi5CardCell *leftCard = (Hi5CardCell *)[self.boardView cardOnLeftOfIndexPath:targetIndexpath];
					
					if(sourceCell.card.suit == leftCard.card.suit)
					{
                        if (leftCard.card.rank == kCardRankEmpty) {
                            [self didFailToSwapCardsWithError:@"For a valid move the left cell should have a card of the same suit and a higher rank"];
                        }
						else if(sourceCell.card.rank-1 == leftCard.card.rank)
						{
							[self swapCellAtIndexPath:sourceIndexpath
                                  withCellAtIndexPath:targetIndexpath];
						}
						else
						{
							[self didFailToSwapCardsWithError:@"The left card rank should be one more than the selected card"];
						}
					}
					else
					{
						[self didFailToSwapCardsWithError:@"The suit of the left card should match with the selected card"];
					}
				}
			}
		}
		else
		{
			[self didFailToSwapCardsWithError:@"you can put the card only in an empty location"];
		}
	}
    }

-(void)didFailToSwapCardsWithError:(NSString *)error
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	[self alertWithTitle:@"Invalid Move" andMessage:error];
}

-(UIAlertView *)alertWithTitle:(NSString *)title andMessage:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
												   delegate:self
										  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
    return alert;
}

@end
