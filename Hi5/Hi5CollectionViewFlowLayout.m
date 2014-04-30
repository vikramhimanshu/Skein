//
//  Hi5CollectionViewFlowLayout.m
//  Hi5
//
//  Created by Himanshu Tantia on 4/29/14.
//
//

#import "Hi5CollectionViewFlowLayout.h"
#import "Hi5CardCell.h"

@interface Hi5CollectionViewFlowLayout ()

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingX;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic, assign) CGSize collectionViewSize;

@end

@implementation Hi5CollectionViewFlowLayout
{
    BOOL isLandscape;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    isLandscape = UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    self.itemInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.itemSize = CGSizeMake(75.0,75.0);
    self.interItemSpacingX = 0;
    self.interItemSpacingY = 0;
}

#pragma mark - Layout

- (void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    CGRect frame = self.collectionView.frame;
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath;
    CGFloat     width = 0;
    CGFloat     height = 0;
    for (NSInteger section = 0; section < sectionCount; section++)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        CGFloat offsetX = self.itemInsets.left;
        CGFloat offsetY = self.itemInsets.top;
        
        for (NSInteger item = 0; item < itemCount; item++)
        {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath
                                                            withOffset:CGPointMake(offsetX, offsetY)];
            
//            if (isLandscape) {
//                offsetX = itemAttributes.frame.origin.y + CGRectGetHeight(itemAttributes.frame);
//                if (offsetX>CGRectGetHeight(frame)) {
//                    offsetX = self.itemInsets.left;
//                    offsetY += itemAttributes.frame.origin.x + CGRectGetWidth(itemAttributes.frame);
//                }
//            }
//            else
//            {
//                offsetX = itemAttributes.frame.origin.x + CGRectGetWidth(itemAttributes.frame);
//                if (offsetX>CGRectGetWidth(frame)) {
//                    offsetX = self.itemInsets.left;
//                    offsetY += itemAttributes.frame.origin.y + CGRectGetHeight(itemAttributes.frame);
//                }
//            }
            
            offsetX = itemAttributes.frame.origin.x + CGRectGetHeight(itemAttributes.frame);
            if (offsetX>CGRectGetHeight(frame)) {
                offsetX = self.itemInsets.left;
                offsetY += itemAttributes.frame.origin.y + CGRectGetWidth(itemAttributes.frame);
            }
            cellLayoutInfo[indexPath] = itemAttributes;
        }
        width = offsetX + self.itemInsets.left + self.itemInsets.right;
        height = offsetY + self.itemInsets.top + self.itemInsets.bottom;
    }
    
    self.collectionViewSize = CGSizeMake(width, height);
    
    newLayoutInfo[[Hi5CardCell reuseIdentifier]] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[[Hi5CardCell reuseIdentifier]][indexPath];
}

- (CGSize)collectionViewContentSize
{
    return self.collectionViewSize;
}

#pragma mark - Private

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath withOffset:(CGPoint)offset
{
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat height = 0;
    CGFloat width = 0;
//    if (isLandscape) {
//        originY = floorf(offset.x + self.interItemSpacingX);
//        originX = floorf(offset.y + self.interItemSpacingY);
//        height = self.itemSize.width;
//        width = self.itemSize.height;
//    }
//    else
//    {
        originX = floorf(offset.x + self.interItemSpacingX);
        originY = floorf(offset.y + self.interItemSpacingY);
        height = self.itemSize.height;
        width = self.itemSize.width;
//    }
    
    CGRect rect = CGRectMake(originX, originY, height, width);
    return rect;
}

@end
