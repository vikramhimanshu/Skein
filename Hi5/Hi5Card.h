//
//  Hi5Card.h
//  Hi5
//
//  Created by Himanshu Tantia on 5/1/14.
//
//

#import <Foundation/Foundation.h>

@interface Hi5Card : NSObject

@property (nonatomic, assign) NSUInteger rank;
@property (nonatomic, assign) NSUInteger suit;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) UIImage *image;
@end
