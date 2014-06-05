//
//  Hi5BoardViewDataSource.h
//  Hi5
//
//  Created by Himanshu Tantia on 6/4/14.
//
//

#import <Foundation/Foundation.h>

@interface Hi5BoardViewDataSource : NSObject

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

@end
