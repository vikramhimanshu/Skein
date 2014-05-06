//
//  Hi5CollectionView.m
//  Hi5
//
//  Created by Himanshu Tantia on 4/24/14.
//
//

#import "Hi5CollectionView.h"
#import "Hi5Card.h"
#import "Hi5CardCell.h"

@interface Hi5CollectionView ()

@property (nonatomic,strong) NSMutableSet *emptyCells;
@property (nonatomic,strong) NSMutableSet *sectionsToCheck;
@property (nonatomic) BOOL completion;
@property (nonatomic) BOOL movesExhausted;

@end

@implementation Hi5CollectionView

-(id<Hi5CollectionViewDelegate>)delegate
{
    return (id<Hi5CollectionViewDelegate>)[super delegate];
}

-(NSArray *)getEmptyCells
{
    return [self.emptyCells allObjects];
}

- (void)resetEmptyCells
{
    [self.emptyCells removeAllObjects];
}

- (void)addEmptyCells:(Hi5CardCell *)cards
{
    if (!self.emptyCells) {
        self.emptyCells = [NSMutableSet new];
    }
    [self.emptyCells addObject:cards];
}

- (void)checkForGameCompletion
{
    _completion = NO;
    NSIndexPath *ip = [NSIndexPath indexPathForItem:0 inSection:0];
    Hi5CardCell *currentCard = (Hi5CardCell *)[super cellForItemAtIndexPath:ip];
    
    for (int i=0; i<[super numberOfSections]; i++)
    {
        for (int j=1; j<[super numberOfItemsInSection:i]-1; j++)
        {
            ip = [NSIndexPath indexPathForItem:j inSection:i];
            currentCard = (Hi5CardCell *)[super cellForItemAtIndexPath:ip];
            Hi5CardCell *adjCard = [self cardOnRightOfCard:currentCard];
            if(adjCard.isActive)
            {
                if ((currentCard.card.rank<adjCard.card.rank) &&
                    ([currentCard.card.name caseInsensitiveCompare:adjCard.card.name] == NSOrderedSame))
                {
                    _completion = YES;
                }
                else
                {
                    _completion = NO;
                    break;
                }
            }
        }
        if (!_completion) break;
    }
    if (_completion || _movesExhausted) {
        [self.delegate didGameEndWithSuccess:_completion];
    }
}

- (void)adjustEmptyCells
{
    _movesExhausted = NO;
    int count = 0;
    NSArray *arr = [self.emptyCells allObjects];
    for (NSInteger i=[arr count]-1; i>=0; i--)
    {
        Hi5CardCell *c = [arr objectAtIndex:i];
        Hi5CardCell *lc = [self setLeftCardActive:c];
        if (lc.card.rank == 5)
        {
            count++;
            [self setRightCardActiveStateTo:NO forCard:c];
        }
        else
        {
            [self setRightCardActiveStateTo:YES forCard:c];
        }
    }
    if (count==4) {
        _movesExhausted = YES;
    }
}

- (void)setRightCardActiveStateTo:(BOOL)yes forCard:(Hi5CardCell *)c
{
    [c setIsActive:yes];
    Hi5CardCell *rc = [self cardOnRightOfCard:c];
    if (rc != nil && rc.card.rank == 0) {
        [self setRightCardActiveStateTo:yes forCard:rc];
    }
}

-(Hi5CardCell *)setLeftCardActive:(Hi5CardCell *)c
{
    Hi5CardCell *lc = [self cardOnLeftOfCard:c];
    
    if (lc==nil || lc.card.rank)
    {
        return lc;
    }
    
    return [self setLeftCardActive:lc];
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
    return [self CardOn:-1 ofCard:card];;
}

- (Hi5CardCell *)cardOnRightOfCard:(Hi5CardCell *)card
{
    return [self CardOn:1 ofCard:card];
}

- (Hi5CardCell *)CardOn:(int)left ofCard:(Hi5CardCell *)card
{
    NSIndexPath *ip = [super indexPathForCell:(UICollectionViewCell *)card];
    NSIndexPath *ipLeft = [NSIndexPath indexPathForItem:ip.item+left inSection:ip.section];
    return (Hi5CardCell *)[super cellForItemAtIndexPath:ipLeft];
}

@end
