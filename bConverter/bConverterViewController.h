//
//  bConverterViewController.h
//  bConverter
//
//  Created by Jury Giannelli on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@interface bConverterViewController : UIViewController <FlipsideViewControllerDelegate> {
    AVAudioPlayer *audioPlayer;
    UIButton *infoButton;
    UIButton *settingsButton;
    UITextField *input;
    UILabel *output;
    UIImageView *glow;
    UIImageView *troll;
    UIImageView *urlImage;
    UIImageView *closed_up;
    UIImageView *closed_down;
    UIScrollView *inputScroll;
    NSString *inputSet;
    UIScrollView *outputScroll;
    NSString *outputSet;
    UIView *pickerView;
    UISwipeGestureRecognizer *drecognizer;
    UISwipeGestureRecognizer *urecognizer;
}

@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UIButton *settingsButton;
@property (nonatomic, retain) IBOutlet UITextField *input;
@property (nonatomic, retain) IBOutlet UILabel *output;
@property (nonatomic, retain) IBOutlet UIImageView *glow;
@property (nonatomic, retain) IBOutlet UIImageView *troll;
@property (nonatomic, retain) IBOutlet UIImageView *urlImage;
@property (nonatomic, retain) IBOutlet UIImageView *closed_up;
@property (nonatomic, retain) IBOutlet UIImageView *closed_down;
@property (nonatomic, retain) IBOutlet UIScrollView *inputScroll;
@property (nonatomic, retain) IBOutlet UIScrollView *outputScroll;
@property (nonatomic, retain) IBOutlet UIView *pickerView;

@property(nonatomic) float decelerationRate;

-(IBAction)endEdit;
-(IBAction)initEdit;
- (void)addImageWithName:(NSString*)imageString atDownPosition:(int)position;
- (void)addImageWithName:(NSString*)imageString atUpPosition:(int)position;
- (void)conversionDidBeginFrom:(inout NSString *)inputSet to:(inout NSString *)outputSet fromValue:(inout NSString *)inputValue;

@end
