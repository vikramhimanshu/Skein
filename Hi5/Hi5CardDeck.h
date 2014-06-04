//
//  Hi5CardDeck.h
//  Hi5
//
//  Created by Himanshu Tantia on 5/1/14.
//
//

#import <Foundation/Foundation.h>

@interface Hi5CardDeck : NSObject

+ (Hi5CardDeck *)sharedInstance;
- (void)shuffle;
- (NSMutableArray *)shuffledDeck;
- (NSMutableArray *)deck;
- (NSUInteger)count;

@end
