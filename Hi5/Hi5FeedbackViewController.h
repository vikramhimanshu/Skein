//
//  Hi5FeedbackViewController.h
//  Hi5
//
//  Created by Himanshu Tantia on 6/5/14.
//
//

#define FEEDBACK_SHORT @"https://docs.google.com/forms/d/1HgiYpeNVLf0lu-oLrQZKKpFi72qIMt5qEqyFQoHzgHc/viewform"

#define FEEDBACK_LONG @"https://docs.google.com/spreadsheet/viewform?formkey=dEJ0ZUFLUDVYQWpGMFc0X1I1dHJ2T3c6MA"
#define GAME_RULES @"https://dl.dropboxusercontent.com/u/29624445/SkeinRules.html"
#define GAME_RULES_1 @"https://dl.dropboxusercontent.com/u/29624445/GameRules.htm"

#import <UIKit/UIKit.h>

@interface Hi5FeedbackViewController : UIViewController

@property (strong, nonatomic) NSString *viewTitle;
@property (strong, nonatomic) NSString *urlToLoad;

-(void)loadPageAtPath:(NSString *)urlString;

@end
