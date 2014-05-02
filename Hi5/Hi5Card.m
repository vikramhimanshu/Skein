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
    [debugStr appendString:@"\n"];
    [debugStr appendFormat:@"\nRank: %d",self.rank];
    [debugStr appendFormat:@"\nSuit: %d",self.suit];
    [debugStr appendFormat:@"\nName: %@",self.name];
    [debugStr appendFormat:@"\nImageName: %@",self.imgName];
    [debugStr appendString:@"\n"];
    return debugStr;
}

@end
