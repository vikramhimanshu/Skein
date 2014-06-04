//
//  Hi5CardDeck.m
//  Hi5
//
//  Created by Himanshu Tantia on 5/1/14.
//
//

#import "Hi5CardDeck.h"
#import "Hi5Card.h"
#import "NSMutableArray+Shuffle.h"

#define NUM_CARD_ROW 6

static NSArray *imgArray;
static Hi5CardDeck *sharedInstance;

@interface Hi5CardDeck ()

@property (nonatomic, strong) NSMutableArray *cardDeck;

@end

@implementation Hi5CardDeck

-(void)dealloc
{
    imgArray = nil;
    [self.cardDeck removeAllObjects];
}

+ (Hi5CardDeck *)sharedInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[Hi5CardDeck alloc] init];
        [self populateImageArray];
    });
    return sharedInstance;
}

+ (void)populateImageArray
{
    imgArray = @[@"spades+1.png",@"spades+2.png",@"spades+3.png",@"spades+4.png",@"spades+5.png",
                 @"empty+0.jpg",
                 @"hearts+1.png",@"hearts+2.png",@"hearts+3.png",@"hearts+4.png",@"hearts+5.png",
                 @"empty+0.jpg",
                 @"clubs+1.png",@"clubs+2.png",@"clubs+3.png",@"clubs+4.png",@"clubs+5.png",
                 @"empty+0.jpg",
                 @"diamonds+1.png",@"diamonds+2.png",@"diamonds+3.png",@"diamonds+4.png",@"diamonds+5.png",
                 @"empty+0.jpg"];
}

- (void)shuffle
{
    [self.cardDeck shuffle];
}

- (NSArray *)cards
{
    NSUInteger numRows = [self count]/NUM_CARD_ROW;
    NSMutableArray *cards = [NSMutableArray new];
    for (int i =0; i<numRows; i++) {
        NSRange r = NSMakeRange(i*NUM_CARD_ROW, NUM_CARD_ROW);
        NSIndexSet *is = [NSIndexSet indexSetWithIndexesInRange:r];
        NSArray *s1 = [NSArray arrayWithArray:[[self deck] objectsAtIndexes:is]];
        [cards addObject:s1];
    }
    return cards;
}

- (NSMutableArray *)shuffledDeck
{
    return [self.cardDeck shuffle];
}

- (NSMutableArray *)deck
{
    return self.cardDeck;
}

- (NSUInteger)count {
    return [self.cardDeck count];
}

- (NSMutableArray *)cardDeck
{
    if (nil == _cardDeck)
    {
        self.cardDeck = [[NSMutableArray alloc] init];
        [self prepareDeck];
    }
    return _cardDeck;
}

- (void)prepareDeck
{
    for (NSString *imageName in imgArray)
    {
        Hi5Card *card = [[Hi5Card alloc] init];
        NSArray *arr = [imageName componentsSeparatedByString:@"+"];
        NSString *suit = [arr objectAtIndex:0];
        NSString *value = [[arr objectAtIndex:1] substringToIndex:([[arr objectAtIndex:1] length]-4)];
        [card setSuit:[card suitForName:suit]];
        [card setRank:[value integerValue]];
        [card setImgName:imageName];
        [self.cardDeck addObject:card];
    }
    return;
}

@end
