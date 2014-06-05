//
//  Hi5Card.m
//  Hi5
//
//  Created by Himanshu Tantia on 5/1/14.
//
//

#import "Hi5Card.h"

@implementation Hi5Card

- (UIImage *)image
{
    return [UIImage imageNamed:self.imgName];
}

-(NSString *)name
{
    switch (self.suit) {
        case kCardSuit1:
            return @"spades";
            break;
        case kCardSuit2:
            return @"hearts";
            break;
        case kCardSuit3:
            return @"clubs";
            break;
        case kCardSuit4:
            return @"diamonds";
            break;
        case kCardSuitEmpty:
            return @"empty";
            break;
    }
    return nil;
}

-(Suit)suitForName:(NSString *)name
{
    name = [name lowercaseString];
    if ([name isEqualToString:@"spades"]) {
        return kCardSuit1;
    } else if ([name isEqualToString:@"hearts"]) {
        return kCardSuit2;
    } else if ([name isEqualToString:@"clubs"]) {
        return kCardSuit3;
    } else if ([name isEqualToString:@"diamonds"]) {
        return kCardSuit4;
    } else if ([name isEqualToString:@"empty"]) {
        return kCardSuitEmpty;
    }
    return kCardSuitEmpty;
}
-(BOOL)isEmpty
{
    return self.rank==kCardRankEmpty;
}
- (NSComparisonResult)cardRankCompare:(Hi5Card *)card
{
    if (self.rank<card.rank) {
        return NSOrderedAscending;
    } else if (self.rank>card.rank) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

- (NSString *)description
{
    NSMutableString *debugStr = [[NSMutableString alloc] init];
    [debugStr appendString:@"\n"];
    [debugStr appendFormat:@"\nRank: %lu",(unsigned long)self.rank];
    [debugStr appendFormat:@"\nSuit: %lu",(unsigned long)self.suit];
    [debugStr appendFormat:@"\nName: %@",self.name];
    [debugStr appendFormat:@"\nImageName: %@",self.imgName];
    [debugStr appendString:@"\n"];
    return debugStr;
}

@end
