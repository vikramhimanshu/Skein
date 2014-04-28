//
//  Hi5MasterViewController.m
//  Hi5
//
//  Created by Himanshu Tantia on 4/22/14.
//
//

#import "Hi5MasterViewController.h"
#import "Hi5CardCell.h"
#import "Hi5DetailViewController.h"

#define NUM_ROWS 6
#define NUM_COLS 4

@interface Hi5MasterViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,Hi5CardCellDelegate> {
    NSMutableArray *imgArray;
}

@property (nonatomic, strong) IBOutlet UICollectionView *boardView;

@end

@implementation Hi5MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imgArray = [[NSMutableArray alloc] init];
	[imgArray addObject:@"spades+1.png"];
	[imgArray addObject:@"spades+2.png"];
	[imgArray addObject:@"spades+3.png"];
	[imgArray addObject:@"spades+4.png"];
	[imgArray addObject:@"spades+5.png"];
	[imgArray addObject:@"empty+0.jpg"];
	[imgArray addObject:@"hearts+1.png"];
	[imgArray addObject:@"hearts+2.png"];
	[imgArray addObject:@"hearts+3.png"];
	[imgArray addObject:@"hearts+4.png"];
	[imgArray addObject:@"hearts+5.png"];
	[imgArray addObject:@"empty+0.jpg"];
	[imgArray addObject:@"clubs+1.png"];
	[imgArray addObject:@"clubs+2.png"];
	[imgArray addObject:@"clubs+3.png"];
	[imgArray addObject:@"clubs+4.png"];
	[imgArray addObject:@"clubs+5.png"];
	[imgArray addObject:@"empty+0.jpg"];
	[imgArray addObject:@"diamonds+1.png"];
	[imgArray addObject:@"diamonds+2.png"];
	[imgArray addObject:@"diamonds+3.png"];
	[imgArray addObject:@"diamonds+4.png"];
	[imgArray addObject:@"diamonds+5.png"];
	[imgArray addObject:@"empty+0.jpg"];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.boardView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 24;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Hi5CardCell *cell = (Hi5CardCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"card" forIndexPath:indexPath];
    cell.delegate = self;
    cell.debugLabel.text = [NSString stringWithFormat:@"%lu",(long)[indexPath item]];
    cell.name = [NSString stringWithFormat:@"Cell Number: %lu",(long)indexPath.item];
    cell.tag = indexPath.item+1;
    
    if([imgArray count]>0)
    {
        NSInteger randomIndex = [self generateIndex];
        if (randomIndex == 0) {
            NSLog(@"");
        }
        NSString *imageName = [imgArray objectAtIndex:randomIndex];
        //Removing the object from the image array because we want unique ramdom numbers
        [imgArray removeObjectAtIndex:randomIndex];
        
        NSArray *arr = [imageName componentsSeparatedByString:@"+"];
        NSString *color = [arr objectAtIndex:0];
        NSString *value = [[arr objectAtIndex:1] substringToIndex:([[arr objectAtIndex:1] length]-4)];
        
        [cell.image setImage:[UIImage imageNamed:imageName]];
        [cell setName:color];
        [cell setRank:[value integerValue]];
    }
    
    return cell;
}

-(NSInteger)generateIndex
{
	if([imgArray count] >0 )
	{
		return (arc4random() % [imgArray count]);
	}
	else
	{
		return 0;
	}
    
}

-(void)didSwapCell:(Hi5CardCell *)sourceCell withCell:(Hi5CardCell *)targetCell atIndexPath:(NSIndexPath *)indexpath
{
    [self willSwapCards:sourceCell withCell:targetCell atIndexPath:indexpath];
}

- (void)swapCell:(Hi5CardCell *)sourceCell withCell:(Hi5CardCell *)targetCell atIndexPath:(NSIndexPath *)indexpath
{
    [self.boardView performBatchUpdates:^{
        [self.boardView moveItemAtIndexPath:[self.boardView indexPathForCell:sourceCell]
                                toIndexPath:indexpath];
        [self.boardView moveItemAtIndexPath:indexpath
                                toIndexPath:[self.boardView indexPathForCell:sourceCell]];
    } completion:nil];
}

-(void)willSwapCards:(Hi5CardCell *)sourceCell withCell:(Hi5CardCell *)targetCell atIndexPath:(NSIndexPath *)indexpath
{
	//Checking if the selected card is valid. i.e. not empty card
	if([sourceCell rank] != 0)
	{
		//Checking if the target card is valid. i.e. an empty card
		if([targetCell rank] == 0)
		{
			//Checking if the selected card is an Ace card;
			if([sourceCell rank] == 1)
			{
				//Ace can only be placed in the first element of any row
				if(indexpath.item == NUM_ROWS*0 ||
				   indexpath.item == NUM_ROWS*1 ||
				   indexpath.item == NUM_ROWS*2 ||
				   indexpath.item == NUM_ROWS*3)
				{
					[self swapCell:sourceCell withCell:targetCell atIndexPath:indexpath];
				}
				else
				{
					[self didFailToSwapCardsWithError:@"An Ace can only occupy the First Coloumn"];
				}
			}
			else
			{
				if(indexpath.item == NUM_ROWS*0 ||
				   indexpath.item == NUM_ROWS*1 ||
				   indexpath.item == NUM_ROWS*2 ||
				   indexpath.item == NUM_ROWS*3)
				{
					[self didFailToSwapCardsWithError:@"You can only place an Ace here"];
				}
				else
				{
                    NSIndexPath *i = [NSIndexPath indexPathForItem:indexpath.item-1 inSection:0];
					Hi5CardCell *leftCard = (Hi5CardCell *)[self.boardView cellForItemAtIndexPath:i];
					
					if([[sourceCell name] caseInsensitiveCompare:[leftCard name]] == NSOrderedSame)
					{
						if([sourceCell rank]-1 == [leftCard rank])
						{
							[self swapCell:sourceCell withCell:targetCell atIndexPath:indexpath];
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
