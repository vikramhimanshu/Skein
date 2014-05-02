//
//  Hi5CollectionView.m
//  Hi5
//
//  Created by Himanshu Tantia on 4/24/14.
//
//

#import "Hi5CollectionView.h"
#import "Hi5Card.h"
#import "Hi5CardCell.h"

@interface Hi5CollectionView ()

@property (nonatomic,strong) NSMutableSet *emptyCells;

@end

@implementation Hi5CollectionView


-(void)awakeFromNib
{
    
}

-(NSArray *)getEmptyCells
{
    return [self.emptyCells allObjects];
}
- (void)resetEmptyCells
{
    [self.emptyCells removeAllObjects];
}
- (void)addEmptyCells:(Hi5CardCell *)cards
{
    if (!self.emptyCells) {
        self.emptyCells = [NSMutableSet new];
    }
    [self.emptyCells addObject:cards];
}

- (void)adjustEmptyCells
{
    int count = 0;
    for (Hi5CardCell *c in self.emptyCells)
    {
        Hi5CardCell *lc = [self cardOnLeftOfCard:c];
        if (lc != nil &&
            ((lc.card.rank==5) ||
             (lc.card.rank==0 && !lc.isActive))) {
            [c setIsActive:NO];
            count++;
        }
        else
            [c setIsActive:YES];
    }
    if (count==4) {
        
    }
}

-(Hi5CardCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    return (Hi5CardCell *)[super dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (Hi5CardCell *)cardOnLeftOfIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *ipLeft = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    return (Hi5CardCell *)[super cellForItemAtIndexPath:ipLeft];
}

- (Hi5CardCell *)cardOnLeftOfCard:(Hi5CardCell *)card
{
    NSIndexPath *ip = [super indexPathForCell:(UICollectionViewCell *)card];
    NSIndexPath *ipLeft = [NSIndexPath indexPathForItem:ip.item-1 inSection:ip.section];
    return (Hi5CardCell *)[super cellForItemAtIndexPath:ipLeft];
}

@end
