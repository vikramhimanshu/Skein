//
//  Hi5CardCell.h
//  Hi5
//
//  Created by Himanshu Tantia on 4/22/14.
//
//

#import <UIKit/UIKit.h>

@protocol Hi5CardCellDelegate;

@interface Hi5CardCell : UICollectionViewCell

@property (nonatomic, weak) id<Hi5CardCellDelegate> delegate;
@property (nonatomic, assign) NSUInteger rank;
@property (nonatomic, assign) NSUInteger cardType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak)   IBOutlet UIImageView *imageView;
@property (nonatomic, weak)   IBOutlet UILabel *debugLabel;

+(NSString *)reuseIdentifier;

@end

@protocol Hi5CardCellDelegate <NSObject>

-(void)willSwapCellAtIndexPath:(NSIndexPath *)sourceIndexpath
           withCellAtIndexPath:(NSIndexPath *)targetIndexpath;
@optional
-(BOOL)shouldDragCell:(Hi5CardCell *)cell
   atIndexPath:(NSIndexPath *)indexPath;
@end