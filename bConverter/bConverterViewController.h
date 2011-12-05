//
//  bConverterViewController.h
//  bConverter
//
//  Created by Jury Giannelli on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bConverterViewController : UIViewController
{
    UITextField *input;
    UILabel *output;
    UIImageView *glow;
    UIImageView *troll;
    UIImage *dec_up;
    UIImage *mask_up;
    UIScrollView *inputScroll;
    UIScrollView *outputScroll;
    UISwipeGestureRecognizer *drecognizer;
    UISwipeGestureRecognizer *urecognizer;
}

@property (nonatomic, retain) IBOutlet UITextField *input;
@property (nonatomic, retain) IBOutlet UILabel *output;
@property (nonatomic, retain) IBOutlet UIImageView *glow;
@property (nonatomic, retain) IBOutlet UIImageView *troll;
@property (nonatomic, retain) IBOutlet UIImage *dec_up;
@property (nonatomic, retain) IBOutlet UIImage *mask_up;
@property (nonatomic, retain) IBOutlet UIScrollView *inputScroll;
@property (nonatomic, retain) IBOutlet UIScrollView *outputScroll;

-(IBAction)endEdit;
-(IBAction)initEdit;
@end
