//
//  Hi5CardCell.h
//  Hi5
//
//  Created by Himanshu Tantia on 4/22/14.
//
//

#import <UIKit/UIKit.h>

@protocol Hi5CardCellDelegate;
@class Hi5Card;

@interface Hi5CardCell : UICollectionViewCell

@property (nonatomic, strong) Hi5Card *card;
@property (nonatomic, weak) id<Hi5CardCellDelegate> delegate;
@property (nonatomic, weak)   IBOutlet UIImageView *imageView;
@property (nonatomic, weak)   IBOutlet UILabel *debugLabel;

+(NSString *)reuseIdentifier;

- (instancetype)initWithCard:(Hi5Card *)card;
- (instancetype)initWithCard:(Hi5Card *)card delegate:(id<Hi5CardCellDelegate>) delegate;

- (void)showBorder:(BOOL)yes;
- (void)populateWithCard:(Hi5Card *)card;

@end

@protocol Hi5CardCellDelegate <UICollectionViewDelegate>

-(void)willSwapCellAtIndexPath:(NSIndexPath *)sourceIndexpath
           withCellAtIndexPath:(NSIndexPath *)targetIndexpath;
@optional
-(BOOL)shouldDragCell:(Hi5CardCell *)cell
          atIndexPath:(NSIndexPath *)indexPath;
@end