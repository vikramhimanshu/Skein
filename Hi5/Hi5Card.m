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

- (NSString *)description
{
    NSMutableString *debugStr = [[NSMutableString alloc] init];
    [debugStr appendFormat:@"Rank: %d",self.rank];
    [debugStr appendFormat:@"Suit: %d",self.suit];
    [debugStr appendFormat:@"Name: %@",self.name];
    [debugStr appendFormat:@"ImageName: %@",self.imgName];
    return debugStr;
}

@end
