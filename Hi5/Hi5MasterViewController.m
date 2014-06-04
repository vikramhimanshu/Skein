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

#define NUM_ROWS 6
#define NUM_COLS 4

@interface Hi5MasterViewController ()  <UICollectionViewDataSource,
                                        Hi5CollectionViewDelegate,
                                        Hi5CardCellDelegate,
                                        UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet Hi5CollectionView *boardView;
@property (nonatomic, strong) Hi5CardDeck *deck;

@property (nonatomic, strong) NSDate *totalTimeInGame;

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

- (IBAction)startNewGame
{
    [self.boardView resetEmptyCells];
    [self.deck shuffle];
    [self.deck cards];
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
    return [[self.deck cards] count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[self.deck cards] objectAtIndex:section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Hi5CardCell *cell = [self.boardView dequeueReusableCellWithReuseIdentifier:[Hi5CardCell reuseIdentifier]
                                                                                 forIndexPath:indexPath];
    cell.delegate = self;
    cell.debugLabel.text = [NSString stringWithFormat:@"%lu",(long)[indexPath item]];
    cell.tag = indexPath.item+1;
    
    Hi5Card *c = [[[self.deck cards] objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
    [cell populateWithCard:c];
    if (c.rank == 0) {
        [self.boardView addEmptyCells:cell];
    }
    if (indexPath.section==3&&indexPath.item==5) {
        [self.boardView adjustEmptyCells];
    }
    return cell;
}

-(void)didGameEndWithSuccess:(BOOL)success
{
    if (success) {
        [[self alertWithTitle:@"Yayyy" andMessage:@"Play Again? :D"] setTag:1];
    }else
        [[self alertWithTitle:@"Meh, Never Mind!!" andMessage:@"Try Again! :)"] setTag:1];
}

-(BOOL)shouldDragCell:(Hi5CardCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    return ([cell.card rank] != 0);
}

-(void)willSwapCellAtIndexPath:(NSIndexPath *)sourceIndexpath withCellAtIndexPath:(NSIndexPath *)targetIndexpath
{
    [self shouldSwapCellAtIndexPath:sourceIndexpath
                withCellAtIndexPath:targetIndexpath];
}

-(void)swapCellAtIndexPath:(NSIndexPath *)sourceIndexpath
       withCellAtIndexPath:(NSIndexPath *)targetIndexpath
{
    Hi5CardCell *targetCell = (Hi5CardCell *)[self.boardView
                                              cellForItemAtIndexPath:targetIndexpath];
    [targetCell showBorder:NO];
    [self.boardView performBatchUpdates:^{
        [self.boardView moveItemAtIndexPath:sourceIndexpath
                                toIndexPath:targetIndexpath];
        [self.boardView moveItemAtIndexPath:targetIndexpath
                                toIndexPath:sourceIndexpath];
    } completion:^(BOOL finished) {
        [targetCell showBorder:YES];
        [self.boardView adjustEmptyCells];
        [self.boardView checkForGameCompletion];
    }];
}

-(void)shouldSwapCellAtIndexPath:(NSIndexPath *)sourceIndexpath
             withCellAtIndexPath:(NSIndexPath *)targetIndexpath
{
    Hi5CardCell *sourceCell = (Hi5CardCell *)[self.boardView cellForItemAtIndexPath:sourceIndexpath];
    Hi5CardCell *targetCell = (Hi5CardCell *)[self.boardView cellForItemAtIndexPath:targetIndexpath];
	//Checking if the selected card is valid. i.e. not empty card
	if([sourceCell.card rank] != 0)
	{
		//Checking if the target card is valid. i.e. an empty card
		if([targetCell.card rank] == 0)
		{
			//Checking if the selected card is an Ace card;
			if([sourceCell.card rank] == 1)
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
						if([sourceCell.card rank]-1 == [leftCard.card rank])
						{
							[self swapCellAtIndexPath:sourceIndexpath
                                  withCellAtIndexPath:targetIndexpath];
						}
						else
						{
							[self didFailToSwapCardsWithError:@"The left card value should be one more than the selected card"];
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
	else
	{
		[self didFailToSwapCardsWithError:@"please select a valid card"];
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
