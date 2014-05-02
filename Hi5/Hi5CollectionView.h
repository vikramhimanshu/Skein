//
//  Hi5CollectionView.h
//  Hi5
//
//  Created by Himanshu Tantia on 4/24/14.
//
//

#import <UIKit/UIKit.h>

@class Hi5CardCell;
@interface Hi5CollectionView : UICollectionView

- (void)resetEmptyCells;
- (void)adjustEmptyCells;
- (NSArray *)getEmptyCells;
- (void)addEmptyCells:(Hi5CardCell *)cards;
- (Hi5CardCell *)cardOnLeftOfIndexPath:(NSIndexPath *)indexPath;
- (Hi5CardCell *)cardOnLeftOfCard:(Hi5CardCell *)card;

@end
