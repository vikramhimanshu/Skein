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

@end
