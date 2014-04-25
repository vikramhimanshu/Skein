//
//  Hi5CardCell.m
//  Hi5
//
//  Created by Himanshu Tantia on 4/22/14.
//
//

#import "Hi5CardCell.h"

@interface Hi5CardCell ()

@property (nonatomic,strong) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic,assign) CGPoint originalCenter;
@property (nonatomic,assign) CGRect originalFrame;
@property (nonatomic,assign) BOOL canRelease;
@property (nonatomic,strong) UIColor *originalBackgroundColor;

@end

@implementation Hi5CardCell

-(void)dealloc
{
    [self removeGestureRecognizer:self.gestureRecognizer];
}

-(void)awakeFromNib
{
    self.type = 0;
    self.rank = 0;
    self.name = @"default";
    self.gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:self.gestureRecognizer];
    [self.layer setBorderWidth:0.5];
    self.originalBackgroundColor = self.backgroundColor;
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    __block NSIndexPath *ip2 = nil;
    __block Hi5CardCell *targetCell = nil;
    __block CGRect newFrame;

    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.originalCenter = self.center;
        self.originalFrame = self.frame;
        [self setBackgroundColor:[UIColor redColor]];
        [[self superview] bringSubviewToFront:self];
    }
    
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x,
                                  _originalCenter.y + translation.y);
        
        ip2 = [(UICollectionView *)[self superview] indexPathForItemAtPoint:self.center];
        targetCell = (Hi5CardCell *)[(UICollectionView *)[self superview] cellForItemAtIndexPath:ip2];
        [targetCell setBackgroundColor:[UIColor greenColor]];
        newFrame = [targetCell frame];
    }
    
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        ip2 = [(UICollectionView *)[self superview] indexPathForItemAtPoint:self.center];
        targetCell = (Hi5CardCell *)[(UICollectionView *)[self superview] cellForItemAtIndexPath:ip2];
        newFrame = [targetCell frame];
        _canRelease = (targetCell!=nil);
        NSLog(@"\n\n\ndropped cell: %@ \nat point %@ \nindexPath %@\n\n",targetCell,NSStringFromCGPoint(self.center),ip2);
        
        if (_canRelease) {
            [UIView animateWithDuration:0.2 animations:^{
                targetCell.frame = self.originalFrame;
                self.frame = newFrame;
            } completion:^(BOOL finished) {
                [self.delegate didSwapCell:self withCell:targetCell atIndexPath:ip2];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = self.originalFrame;
            }];
        }
    }
}

@end
