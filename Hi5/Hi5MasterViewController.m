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

@interface Hi5MasterViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,Hi5CardCellDelegate>

@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) IBOutlet UICollectionView *boardView;
@property (nonatomic, strong) NSMutableArray *cardsArray;

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
//    self.boardView.frame = CGRectMake(0, 0, 320, 480);
//    self.boardView.bounds = self.boardView.frame;
    [self.boardView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"empty+0.jpg"]]];
    UICollectionViewFlowLayout *fl = (UICollectionViewFlowLayout *)[self.boardView collectionViewLayout];
    [fl setMinimumInteritemSpacing:0.0];
    [fl setMinimumLineSpacing:0.0];
//    [fl setSectionInset:UIEdgeInsetsZero];
    
//    CGFloat width = self.boardView.bounds.size.height / 6;
    [fl setItemSize:CGSizeMake(75, 75)];
    
//    [fl setItemSize:CGSizeMake(75, 75)];
//    [self.boardView setCollectionViewLayout:fl];
    [self startNewGame];
    
//    int count = 24;
//    while (count>0) {
//        u_int32_t ri = (arc4random() % count--);
//        NSLog(@"%d %d",count,ri);
//    }
}

-(NSMutableArray *)imgArray
{
    if(!_imgArray)
    {
        _imgArray = [[NSMutableArray alloc] initWithCapacity:24];
    }
    return _imgArray;
}

- (IBAction)startNewGame
{
    [self populateImageArray];
    [self buildCardsArray];
    [self.boardView reloadData];
}

- (void)populateImageArray
{
    [self.imgArray removeAllObjects];
    [self.imgArray addObject:@"spades+1.png"];
	[self.imgArray addObject:@"spades+2.png"];
	[self.imgArray addObject:@"spades+3.png"];
	[self.imgArray addObject:@"spades+4.png"];
	[self.imgArray addObject:@"spades+5.png"];
	[self.imgArray addObject:@"empty+0.jpg"];
	[self.imgArray addObject:@"hearts+1.png"];
	[self.imgArray addObject:@"hearts+2.png"];
	[self.imgArray addObject:@"hearts+3.png"];
	[self.imgArray addObject:@"hearts+4.png"];
	[self.imgArray addObject:@"hearts+5.png"];
	[self.imgArray addObject:@"empty+0.jpg"];
	[self.imgArray addObject:@"clubs+1.png"];
	[self.imgArray addObject:@"clubs+2.png"];
	[self.imgArray addObject:@"clubs+3.png"];
	[self.imgArray addObject:@"clubs+4.png"];
	[self.imgArray addObject:@"clubs+5.png"];
	[self.imgArray addObject:@"empty+0.jpg"];
	[self.imgArray addObject:@"diamonds+1.png"];
	[self.imgArray addObject:@"diamonds+2.png"];
	[self.imgArray addObject:@"diamonds+3.png"];
	[self.imgArray addObject:@"diamonds+4.png"];
	[self.imgArray addObject:@"diamonds+5.png"];
	[self.imgArray addObject:@"empty+0.jpg"];
}

-(void)buildCardsArray
{
    
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 24;//[self.cardsArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Hi5CardCell *cell = (Hi5CardCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[Hi5CardCell reuseIdentifier]
                                                                                 forIndexPath:indexPath];
    cell.delegate = self;
    cell.debugLabel.text = [NSString stringWithFormat:@"%lu",(long)[indexPath item]];
    cell.name = [NSString stringWithFormat:@"Cell Number: %lu",(long)indexPath.item];
    cell.tag = indexPath.item+1;
    
    if([_imgArray count]>0)
    {
        NSInteger randomIndex = [self generateIndex];
        NSString *imageName = [_imgArray objectAtIndex:randomIndex];
        //Removing the object from the image array because we want unique ramdom numbers
        [_imgArray removeObjectAtIndex:randomIndex];
        
        NSArray *arr = [imageName componentsSeparatedByString:@"+"];
        NSString *color = [arr objectAtIndex:0];
        NSString *value = [[arr objectAtIndex:1] substringToIndex:([[arr objectAtIndex:1] length]-4)];
        
        [cell.imageView setImage:[UIImage imageNamed:imageName]];
        [cell setName:color];
        [cell setRank:[value integerValue]];
//        [self markSpaceAsInValid:indexPath];
    }
    
    return cell;
}

- (void)markSpaceAsInValid:(NSIndexPath *)indexPath
{
    Hi5CardCell *cell = (Hi5CardCell *)[self.boardView cellForItemAtIndexPath:indexPath];
    if (cell.rank==5) {
        Hi5CardCell *rightCell = (Hi5CardCell *)[self.boardView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1
                                                                                                          inSection:indexPath.section]];
        if (rightCell.rank==0) {
            rightCell.userInteractionEnabled = NO;
            [rightCell.contentView setBackgroundColor:[UIColor colorWithWhite:1 alpha:.65]];
        }
    }
}

-(NSInteger)generateIndex
{
	if([_imgArray count] >0 )
	{
        u_int32_t ri = (arc4random() % [_imgArray count]);
        NSLog(@"%lu %d",(unsigned long)[_imgArray count],ri);
		return ri;
	}
	else
	{
		return 0;
	}
}

-(BOOL)shouldDragCell:(Hi5CardCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    return ([cell rank] != 0);
}

-(void)willSwapCellAtIndexPath:(NSIndexPath *)sourceIndexpath withCellAtIndexPath:(NSIndexPath *)targetIndexpath
{
    [self shouldSwapCellAtIndexPath:sourceIndexpath
                withCellAtIndexPath:targetIndexpath];
}

-(void)swapCellAtIndexPath:(NSIndexPath *)sourceIndexpath
       withCellAtIndexPath:(NSIndexPath *)targetIndexpath
{
    [self.boardView performBatchUpdates:^{
        [self.boardView moveItemAtIndexPath:sourceIndexpath
                                toIndexPath:targetIndexpath];
        [self.boardView moveItemAtIndexPath:targetIndexpath
                                toIndexPath:sourceIndexpath];
    } completion:^(BOOL finished) {
//        [self markSpaceAsInValid:sourceIndexpath];
//        [self markSpaceAsInValid:targetIndexpath];
    }];
}

-(void)shouldSwapCellAtIndexPath:(NSIndexPath *)sourceIndexpath
             withCellAtIndexPath:(NSIndexPath *)targetIndexpath
{
    Hi5CardCell *sourceCell = (Hi5CardCell *)[self.boardView cellForItemAtIndexPath:sourceIndexpath];
    Hi5CardCell *targetCell = (Hi5CardCell *)[self.boardView cellForItemAtIndexPath:targetIndexpath];
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
				if(targetIndexpath.item == NUM_ROWS*0 ||
				   targetIndexpath.item == NUM_ROWS*1 ||
				   targetIndexpath.item == NUM_ROWS*2 ||
				   targetIndexpath.item == NUM_ROWS*3)
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
				if(targetIndexpath.item == NUM_ROWS*0 ||
				   targetIndexpath.item == NUM_ROWS*1 ||
				   targetIndexpath.item == NUM_ROWS*2 ||
				   targetIndexpath.item == NUM_ROWS*3)
				{
					[self didFailToSwapCardsWithError:@"You can only place an Ace here"];
				}
				else
				{
                    NSIndexPath *i = [NSIndexPath indexPathForItem:targetIndexpath.item-1 inSection:0];
					Hi5CardCell *leftCard = (Hi5CardCell *)[self.boardView cellForItemAtIndexPath:i];
					
					if([[sourceCell name] caseInsensitiveCompare:[leftCard name]] == NSOrderedSame)
					{
						if([sourceCell rank]-1 == [leftCard rank])
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
