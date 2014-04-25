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

@interface Hi5MasterViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,Hi5CardCellDelegate> {
    NSMutableArray *_objects;
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
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self.navigationController setNavigationBarHidden:YES];
    
    for (int i=0; i<24; i++) {
        [self insertNewObject:nil];
    }
    [self.boardView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.boardView insertItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _objects.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Hi5CardCell *cell = (Hi5CardCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"card" forIndexPath:indexPath];
    cell.delegate = self;
    cell.debugLabel.text = [NSString stringWithFormat:@"%lu",(long)[indexPath item]];
    cell.name = [NSString stringWithFormat:@"Cell Number: %lu",(long)indexPath.item];
    cell.tag = indexPath.item;
    return cell;
}

-(void)didSwapCell:(Hi5CardCell *)sourceCell withCell:(Hi5CardCell *)targetCell atIndexPath:(NSIndexPath *)indexpath
{
    [self.boardView performBatchUpdates:^{
        [self.boardView moveItemAtIndexPath:[self.boardView indexPathForCell:sourceCell]
                                toIndexPath:indexpath];
        [self.boardView moveItemAtIndexPath:indexpath
                                toIndexPath:[self.boardView indexPathForCell:sourceCell]];
    } completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [[self.boardView indexPathsForSelectedItems] firstObject];
        NSDate *object = _objects[indexPath.item];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
