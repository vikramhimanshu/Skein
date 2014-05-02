//
//  Hi5MasterViewController.m
//  Hi5
//
//  Created by Himanshu Tantia on 4/22/14.
//
//

#import "Hi5MasterViewController.h"
#import "Hi5CollectionView.h"
#import "Hi5CardCell.h"
#import "Hi5CardDeck.h"
#import "Hi5Card.h"

#define NUM_ROWS 6
#define NUM_COLS 4

@interface Hi5MasterViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,Hi5CardCellDelegate>

@property (nonatomic, strong) IBOutlet Hi5CollectionView *boardView;
@property (nonatomic, strong) Hi5CardDeck *deck;
@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation Hi5MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.boardView.layer setBorderWidth:0.5];
    [self.boardView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"empty+0.jpg"]]];
    UICollectionViewFlowLayout *fl = (UICollectionViewFlowLayout *)[self.boardView collectionViewLayout];
    [fl setMinimumInteritemSpacing:0.0];
    [fl setMinimumLineSpacing:0.0];
    [fl setItemSize:CGSizeMake(75, 75)];
    
    [self startNewGame];
}

- (IBAction)startNewGame
{
    self.deck = [Hi5CardDeck sharedInstance];
    [self.deck shuffledDeck];
    
    NSIndexSet *is = [NSIndexSet indexSetWithIndexesInRange:NSRangeFromString(@"0,6")];
    NSArray *s1 = [NSArray arrayWithArray:[[self.deck deck] objectsAtIndexes:is]];
    self.cards = [NSMutableArray arrayWithObjects:s1, nil];
    
    is = [NSIndexSet indexSetWithIndexesInRange:NSRangeFromString(@"6,6")];
    s1 = [NSArray arrayWithArray:[[self.deck deck] objectsAtIndexes:is]];
    [self.cards addObject:s1];
    
    is = [NSIndexSet indexSetWithIndexesInRange:NSRangeFromString(@"12,6")];
    s1 = [NSArray arrayWithArray:[[self.deck deck] objectsAtIndexes:is]];
    [self.cards addObject:s1];
    
    is = [NSIndexSet indexSetWithIndexesInRange:NSRangeFromString(@"18,6")];
    s1 = [NSArray arrayWithArray:[[self.deck deck] objectsAtIndexes:is]];
    [self.cards addObject:s1];
    
    [self.boardView reloadData];
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.cards count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.cards objectAtIndex:section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Hi5CardCell *cell = [self.boardView dequeueReusableCellWithReuseIdentifier:[Hi5CardCell reuseIdentifier]
                                                                                 forIndexPath:indexPath];
    cell.delegate = self;
    cell.debugLabel.text = [NSString stringWithFormat:@"%lu",(long)[indexPath item]];
    cell.tag = indexPath.item+1;
    
    Hi5Card *c = [[self.cards objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
    [cell populateWithCard:c];
    return cell;
}

- (void)markSpaceAsInValid:(NSIndexPath *)indexPath
{
    Hi5CardCell *cell = (Hi5CardCell *)[self.boardView cellForItemAtIndexPath:indexPath];
    if (cell.card.rank == 5) {
        Hi5CardCell *rightCell = (Hi5CardCell *)[self.boardView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1
                                                                                                          inSection:indexPath.section]];
        if (rightCell.card.rank==0) {
            rightCell.userInteractionEnabled = NO;
            [rightCell.contentView setBackgroundColor:[UIColor colorWithWhite:1 alpha:.65]];
        }
    }
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
        
        Hi5CardCell *targetCell = (Hi5CardCell *)[self.boardView
                                                  cellForItemAtIndexPath:targetIndexpath];
        Hi5CardCell *sourceCell = (Hi5CardCell *)[self.boardView
                                                  cellForItemAtIndexPath:sourceIndexpath];
        Hi5CardCell *lc1 = [self.boardView cardOnLeftOfIndexPath:targetIndexpath];
        Hi5CardCell *lc2 = [self.boardView cardOnLeftOfIndexPath:sourceIndexpath];
        NSLog(@"card%@\nOnLeftOfCard%@",[lc1.card description],[targetCell.card description]);
        NSLog(@"card%@\nOnLeftOfCard%@",[lc2.card description],[sourceCell.card description]);
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
					
					if([[sourceCell.card name] caseInsensitiveCompare:[leftCard.card name]] == NSOrderedSame)
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
						[self didFailToSwapCardsWithError:@"The color of the left card should match with the selected card"];
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
	[self alert:error];
}

-(void)alert:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Move" message:message
												   delegate:self
										  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
}


@end
