//
//  UILabel+nsobject.m
//  Hi5
//
//  Created by Himanshu Tantia on 4/25/14.
//
//

#import "UILabel+nsobject.h"

@implementation UILabel (nsobject)

-(id)copy
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:self.frame];
    duplicateLabel.text = self.text;
    duplicateLabel.textColor = self.textColor;
    return duplicateLabel;
}

@end
