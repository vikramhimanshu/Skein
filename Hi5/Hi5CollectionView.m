//
//  Hi5CollectionView.m
//  Hi5
//
//  Created by Himanshu Tantia on 4/24/14.
//
//

#import "Hi5CollectionView.h"

@class Hi5CardCell;
@implementation Hi5CollectionView


-(void)awakeFromNib
{
    
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
