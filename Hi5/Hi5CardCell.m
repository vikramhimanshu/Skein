//
//  Hi5CardCell.m
//  Hi5
//
//  Created by Himanshu Tantia on 4/22/14.
//
//

#import "Hi5CardCell.h"
#import "UILabel+nsobject.h"

@interface Hi5CardCell ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic,assign) CGPoint originalCenter;
@property (nonatomic,assign) CGRect originalFrame;
@property (nonatomic,assign) BOOL canRelease;
@property (nonatomic,strong) UIColor *originalBackgroundColor;
@property (nonatomic,strong) Hi5CardCell *draggableView;
@end

@implementation Hi5CardCell

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    if (copy) {
        [copy setFrame:self.frame];
        [copy setOriginalCenter:self.originalCenter];
        [copy setOriginalFrame:self.originalFrame];
        [copy setRank:self.rank];
        [copy setCardType:self.cardType];
        UIImageView *imageViewCopy = [[UIImageView alloc] initWithFrame:self.imageView.frame];
        [imageViewCopy setImage:self.imageView.image];
        [copy addSubview:imageViewCopy];
        [copy setName:[self.name copy]];
        [copy addSubview:[self.debugLabel copy]];
        [copy awakeFromNib];
    }
    return copy;
}

-(void)dealloc
{
    [self removeGestureRecognizer:self.gestureRecognizer];
}

-(void)awakeFromNib
{
    self.gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(handlePanGesture:)];
    [self.gestureRecognizer setDelegate:self];
    [self addGestureRecognizer:self.gestureRecognizer];
    [self.layer setBorderWidth:0.5];
    self.originalBackgroundColor = self.backgroundColor;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = NO;
    if ([self.gestureRecognizers containsObject:self.gestureRecognizer]) {
        shouldBegin = YES;
        if ([self.delegate respondsToSelector:@selector(cellShouldDrag:forItemAtIndexPath:)]) {
            shouldBegin = [self.delegate cellShouldDrag:self
                                     forItemAtIndexPath:[(UICollectionView *)[self superview] indexPathForCell:self]];
        }
    }
    return shouldBegin;
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.originalCenter = self.center;
        self.originalFrame = self.frame;
        self.draggableView = [self copy];
        [self.draggableView setAlpha:0.65];
        [self.draggableView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
        [[self superview] addSubview:self.draggableView];
        [self.window bringSubviewToFront:self.draggableView];
//        NSLog(@"\n\nDragged>>>\n\n");
//        [self logCellAtPoint:self.center];
//        NSLog(@"\n\nDragged<<<\n\n");
    }
    
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
//        NSLog(@"translation %@",NSStringFromCGPoint(translation));
        self.draggableView.center = CGPointMake(_originalCenter.x + translation.x,
                                                _originalCenter.y + translation.y);
    }
    
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        NSIndexPath *targetCellIndexPath = [(UICollectionView *)[self superview] indexPathForItemAtPoint:self.draggableView.center];
        NSIndexPath *selfIndexPath = [(UICollectionView *)[self superview] indexPathForCell:self];
        
        _canRelease = ([targetCellIndexPath isEqual:NULL]||
                       ![targetCellIndexPath isEqual:selfIndexPath]);
        
        if (_canRelease) {
            [self.draggableView removeFromSuperview];
            [UIView animateWithDuration:0.4 animations:^{
                [self.draggableView setAlpha:0.0];
                [self.draggableView removeFromSuperview];
            } completion:^(BOOL finished) {
                [self.delegate willSwapCellAtIndexPath:selfIndexPath
                                   withCellAtIndexPath:targetCellIndexPath];
            }];
        }
        else
        {
            NSLog(@"InvalidDrop->IndexPath: %@",targetCellIndexPath);
            [UIView animateWithDuration:0.2 animations:^{
                self.draggableView.frame = self.originalFrame;
                [self.draggableView removeFromSuperview];
            }];
        }
    }
}

//- (void)logCellAtPoint:(CGPoint)p
//{
//    NSIndexPath *ip = [(UICollectionView *)[self superview] indexPathForItemAtPoint:p];
//    Hi5CardCell *targetCell = (Hi5CardCell *)[(UICollectionView *)[self superview] cellForItemAtIndexPath:ip];
////    NSLog(@"\n\n\ncell: %@ \natPoint: %@ \nwithIndexPath: %d\n\n",targetCell.debugLabel.text,NSStringFromCGPoint(self.draggableView.center),ip.item);
//}

@end
