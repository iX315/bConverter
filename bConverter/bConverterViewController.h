//
//  bConverterViewController.h
//  bConverter
//
//  Created by Jury Giannelli on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface bConverterViewController : UIViewController
{
    AVAudioPlayer *audioPlayer;
    UITextField *input;
    UILabel *output;
    UIImageView *glow;
    UIImageView *troll;
    UIImageView *closed_up;
    UIImageView *closed_down;
    UIScrollView *inputScroll;
    UIScrollView *outputScroll;
    UIView *pickerView;
    UISwipeGestureRecognizer *drecognizer;
    UISwipeGestureRecognizer *urecognizer;
}

@property (nonatomic, retain) IBOutlet UITextField *input;
@property (nonatomic, retain) IBOutlet UILabel *output;
@property (nonatomic, retain) IBOutlet UIImageView *glow;
@property (nonatomic, retain) IBOutlet UIImageView *troll;
@property (nonatomic, retain) IBOutlet UIImageView *closed_up;
@property (nonatomic, retain) IBOutlet UIImageView *closed_down;
@property (nonatomic, retain) IBOutlet UIScrollView *inputScroll;
@property (nonatomic, retain) IBOutlet UIScrollView *outputScroll;
@property (nonatomic, retain) IBOutlet UIView *pickerView;

-(IBAction)endEdit;
-(IBAction)initEdit;
- (void)addImageWithName:(NSString*)imageString atUpPosition:(int)position;
- (void)addImageWithName:(NSString*)imageString atDownPosition:(int)position;

@end
