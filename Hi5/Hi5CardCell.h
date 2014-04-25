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
@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak)   IBOutlet UIImageView *image;

@end

@protocol Hi5CardCellDelegate <NSObject>

-(void)didSwapCell:(Hi5CardCell *)sourceCell withCell:(Hi5CardCell *)targetCell atIndexPath:(NSIndexPath *)indexpath;

@end
