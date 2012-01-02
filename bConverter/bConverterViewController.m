//
//  bConverterViewController.m
//  bConverter
//
//  Created by Jury Giannelli on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "bConverterViewController.h"
#import "inputScrollController.h"

@implementation bConverterViewController

@synthesize input;
@synthesize output;
@synthesize glow;
@synthesize troll;
@synthesize closed_up;
@synthesize closed_down;
@synthesize outputScroll;
@synthesize pickerView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];
    //[inputScrollController class];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    closed_up.transform = CGAffineTransformMakeTranslation(0.0,-200.0);
    closed_down.transform = CGAffineTransformMakeTranslation(0.0,200.0);
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/shutter.caf", [[NSBundle mainBundle] resourcePath]]];
    
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = 0;
    
	if (audioPlayer == nil)
		NSLog(@"%@", error.description);
	else
		[audioPlayer play];
    
    [UIView commitAnimations];
    
    [outputScroll setCanCancelContentTouches:NO];
	outputScroll.clipsToBounds = NO;		// default is NO, we want to restrict drawing within our inputScroll
	outputScroll.scrollEnabled = YES;
	outputScroll.pagingEnabled = NO;
    
    [self addImageWithName:@"buttons_down_hex.png" atDownPosition:-2];
    [self addImageWithName:@"buttons_down_ott.png" atDownPosition:-1];
    [self addImageWithName:@"buttons_down_dec.png" atDownPosition:0];
    [self addImageWithName:@"buttons_down_bin.png" atDownPosition:1];
	[self addImageWithName:@"buttons_down_hex.png" atDownPosition:2];
    [self addImageWithName:@"buttons_down_ott.png" atDownPosition:3];
    [self addImageWithName:@"buttons_down_dec.png" atDownPosition:4];
    [self addImageWithName:@"buttons_down_bin.png" atDownPosition:5];
	[self addImageWithName:@"buttons_down_hex.png" atDownPosition:6];
    [self addImageWithName:@"buttons_down_ott.png" atDownPosition:7];
    [self addImageWithName:@"buttons_down_dec.png" atDownPosition:8];
    [self addImageWithName:@"buttons_down_bin.png" atDownPosition:9];
	[self addImageWithName:@"buttons_down_hex.png" atDownPosition:10];
    
    outputScroll.contentSize = CGSizeMake(640, 0);
    [outputScroll setContentOffset:CGPointMake(120,0) animated:YES];
    
    [input setFont:[UIFont fontWithName:@"WW Digital" size:30.0]];
    [output setFont:[UIFont fontWithName:@"WW Digital" size:30.0]];
    
    
    CALayer *lp= [CALayer layer];
    lp.frame = pickerView.bounds;
    lp.contents = (__bridge id)[[UIImage imageNamed:(@"mask.png")] CGImage];
    pickerView.layer.mask = lp;
    
    drecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    [drecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:drecognizer];
    urecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    [urecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:urecognizer];
} 

-(IBAction)endEdit {
    [input resignFirstResponder];
        
    NSString *inputValue = [input text];
    //snippets converters here
    if ([inputValue isEqualToString:@"artofapps"]) {
        [output setText:@"credits"];
    }else if ([inputValue isEqualToString:@"troll"]) {
        troll.alpha = 1.0;
        [output setText:nil];
    } else {
        //look for buttons contentOffset->x
        
        
        /*
        //DEC TO BIN
        NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
        if(inputValue.integerValue > 0){
            for(NSInteger numberCopy = inputValue.integerValue; numberCopy > 0; numberCopy >>= 1){	
                // Prepend "0" or "1", depending on the bit
                [str insertString:((numberCopy & 1) ? @"1" : @"0") atIndex:0];
            }
        }
        else if(inputValue.integerValue == 0){
            [str insertString:@"0" atIndex:0];
        }
        [output setText:str];
        */
    }
    [[self view] addGestureRecognizer:drecognizer];
    [[self view] addGestureRecognizer:urecognizer];
}



-(IBAction)initEdit {
    [[self view] removeGestureRecognizer:urecognizer];
    [[self view] removeGestureRecognizer:drecognizer];
}

#pragma mark - Animations

-(void)handleSwipeDown:(UISwipeGestureRecognizerDirection *)sender {
    //NSLog(@"Swipe received.");
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(animation_end:) userInfo:nil repeats:NO];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    input.transform = CGAffineTransformMakeTranslation(0.0,140.0);        
    [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(alpha_on:) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(alpha_back:) userInfo:nil repeats:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    [[self view] removeGestureRecognizer:urecognizer];
    [[self view] removeGestureRecognizer:drecognizer];
    output.transform = CGAffineTransformMakeTranslation(0.0,140.0);
    troll.transform = CGAffineTransformMakeTranslation(0.0,140.0);
    [UIView commitAnimations];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/swipe.caf", [[NSBundle mainBundle] resourcePath]]];
    
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = 0;
    
	if (audioPlayer == nil)
		NSLog(@"%@", error.description);
	else
		[audioPlayer play];
}

-(void)handleSwipeUp:(UISwipeGestureRecognizerDirection *)sender {
     //NSLog(@"Swipe received.");
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(animation_end:) userInfo:nil repeats:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    output.transform = CGAffineTransformMakeTranslation(0.0,0.0);
    troll.transform = CGAffineTransformMakeTranslation(0.0,0.0);
    [UIView commitAnimations];
            
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    [[self view] removeGestureRecognizer:urecognizer];
    [[self view] removeGestureRecognizer:drecognizer];
    input.transform = CGAffineTransformMakeTranslation(0.0,0.0);
    [UIView commitAnimations];
}


- (void)alpha_on:(NSTimer *)thetime {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
    glow.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)alpha_back:(NSTimer *)thetime {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
    glow.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)animation_end:(NSTimer *)thetime {
    [[self view] addGestureRecognizer:drecognizer];
    [[self view] addGestureRecognizer:urecognizer];
}

#pragma mark - UI



- (void)addImageWithName:(NSString*)imageString atDownPosition:(int)position {
	// add image to scroll view
	UIImage *imageDown = [UIImage imageNamed:imageString];
	UIImageView *imageDownView = [[UIImageView alloc] initWithImage:imageDown];
	imageDownView.frame = CGRectMake(position*80, 0, 80, 86);
	[outputScroll addSubview:imageDownView];
}


//////////////////////////////////////////


//////////////////////////////////////////


#pragma mark - Others

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
