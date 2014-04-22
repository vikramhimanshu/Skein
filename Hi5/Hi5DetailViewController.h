//
//  Hi5DetailViewController.h
//  Hi5
//
//  Created by Himanshu Tantia on 4/22/14.
//
//

#import <UIKit/UIKit.h>

@interface Hi5DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
