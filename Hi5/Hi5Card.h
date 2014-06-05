//
//  Hi5Card.h
//  Hi5
//
//  Created by Himanshu Tantia on 5/1/14.
//
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HiCardOneLess,
    HiCardOneGreater,
    HiCardSame,
    HiCardEmpty
} HiCardComparisonResult;

typedef enum : NSUInteger {
    kCardSuit1 = 0,
    kCardSuit2 = 1,
    kCardSuit3 = 2,
    kCardSuit4 = 3,
    kCardSuitEmpty = 4
} Suit;

typedef enum : NSUInteger {
    kCardRankLowest = 1,
    kCardRank2 = 2,
    kCardRank3 = 3,
    kCardRank4 = 4,
    kCardRankHighest = 5,
    kCardRankEmpty = 0
} Rank;

@interface Hi5Card : NSObject

@property (nonatomic, assign) Rank rank;
@property (nonatomic, assign) Suit suit;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) UIImage *image;

-(Suit)suitForName:(NSString *)name;
-(BOOL)isEmpty;

@end
