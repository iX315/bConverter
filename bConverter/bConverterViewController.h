//
//  bConverterViewController.h
//  bConverter
//
//  Created by Jury Giannelli on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "FBConnect.h"
#import "DETweetTextView.h"
#import <CoreMotion/CoreMotion.h>

@interface bConverterViewController : UIViewController <FlipsideViewControllerDelegate, FBRequestDelegate, FBDialogDelegate, FBSessionDelegate, UIAlertViewDelegate> {
    AVAudioPlayer *audioPlayer;
    UIButton *infoButton;
    UITextField *input;
    UILabel *output;
    UIImageView *glow;
    UIImageView *troll;
    UIButton *fb;
    UIButton *tw;
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
    //UISwipeGestureRecognizer *rrecognizer;
    //UISwipeGestureRecognizer *lrecognizer;
    CMAcceleration *accelerometer;
    
    NSString *inputScrollSet;
    NSString *outputScrollSet;
    //facebook
    Facebook* _facebook;
    NSArray* _permissions;
    IBOutlet UIView *viewPostOnFacebook;
    //IBOutlet UITextView *txtPostMessage;
    IBOutlet DETweetTextView *txtPostMessage;

}

@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UITextField *input;
@property (nonatomic, retain) IBOutlet UILabel *output;
@property (nonatomic, retain) IBOutlet UIImageView *glow;
@property (nonatomic, retain) IBOutlet UIImageView *troll;
@property (nonatomic, retain) IBOutlet UIButton *fb;
@property (nonatomic, retain) IBOutlet UIButton *tw;
@property (nonatomic, retain) IBOutlet UIImageView *urlImage;
@property (nonatomic, retain) IBOutlet UIImageView *closed_up;
@property (nonatomic, retain) IBOutlet UIImageView *closed_down;
@property (nonatomic, retain) IBOutlet UIScrollView *inputScroll;
@property (nonatomic, retain) IBOutlet UIScrollView *outputScroll;
@property (nonatomic, retain) IBOutlet UIView *pickerView;
@property(readonly) Facebook *facebook;

@property(nonatomic) float decelerationRate;

-(NSString *)GetTwitterPost;

-(NSString *)Concat:(NSString *)s1 with:(NSString *)s2;
-(NSString *)Concat:(NSString *)s1 with:(NSString *)s2 withSpace:(BOOL)withSpace;

-(IBAction)endEdit;
-(IBAction)initEdit;
-(IBAction)ShareAppViaTwitter:(id)sender;
-(IBAction)ShareAppViaFacebook:(id)sender;

- (void)addImageWithName:(NSString*)imageString atPosition:(int)position toScrollView:(UIScrollView*)scrollView;
- (void)conversionDidBeginFrom:(inout NSString *)inputSet to:(inout NSString *)outputSet fromValue:(inout NSString *)inputValue;
- (CGSize)calcProps;

//facebook
-(void)DoLogin;
-(void)loginToFacebook:(id)sender;
-(void)publishStream:(id)sender;
-(void)uploadFoto:(id)sender;
-(IBAction)postOnFacebook;
-(IBAction)cancelPostOnFacebook;
-(void)ShowFacebookDialog;
-(void)HideFacebookDialog;
-(NSString *)GetFacebookPost;
-(NSString *)GetTwitterPost;

- (NSString *)bits:(NSInteger)value forSize:(int)size;
- (NSString *)bitsForInteger:(NSInteger)value;
- (NSString *)bitsForString:(NSString *)value;

-(void)showMsgBox:(NSString *)text withTitle:(NSString *)title cancelButtonText:(NSString *)cText otherButtonText:(NSString *)cOther;
@end
