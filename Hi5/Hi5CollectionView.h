//
//  Hi5CollectionView.h
//  Hi5
//
//  Created by Himanshu Tantia on 4/24/14.
//
//

#import <UIKit/UIKit.h>

@class Hi5CardCell;
@protocol Hi5CollectionViewDelegate;

@interface Hi5CollectionView : UICollectionView

@property (nonatomic,weak) id<Hi5CollectionViewDelegate> delegate;

- (void)checkForGameCompletion;
- (void)resetEmptyCells;
- (void)adjustEmptyCells;
- (NSArray *)getEmptyCells;
- (void)addEmptyCells:(Hi5CardCell *)cards;
- (Hi5CardCell *)cardOnLeftOfIndexPath:(NSIndexPath *)indexPath;
- (Hi5CardCell *)cardOnLeftOfCard:(Hi5CardCell *)card;

@end

@protocol Hi5CollectionViewDelegate <UICollectionViewDelegate>

-(void)didGameEndWithSuccess:(BOOL)success;

@end