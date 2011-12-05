//
//  bConverterViewController.m
//  bConverter
//
//  Created by Jury Giannelli on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "bConverterViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation bConverterViewController

@synthesize input;
@synthesize output;
@synthesize glow;
@synthesize troll;
@synthesize mask_up;
@synthesize dec_up;
@synthesize inputScroll;
@synthesize outputScroll;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //UIImageView * roundedView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"mask_up.png"]];
    // Get the Layer of any view
    CAGradientLayer *li = [CAGradientLayer layer];
    li.frame = inputScroll.bounds;
    li.colors = [NSArray arrayWithObjects:(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)[UIColor clearColor].CGColor, nil];
    li.endPoint = CGPointMake(0.5f, 0.0f);
    li.startPoint = CGPointMake(0.5f, 1.0f);
    inputScroll.layer.mask = li;
    
    CAGradientLayer *lo= [CAGradientLayer layer];
    lo.frame = outputScroll.bounds;
    lo.colors = [NSArray arrayWithObjects:(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)[UIColor clearColor].CGColor, nil];
    lo.startPoint = CGPointMake(0.5f, 0.0f);
    lo.endPoint = CGPointMake(0.5f, 1.0f);
    outputScroll.layer.mask = lo;
    
    /*
    UIView *mask = [[CustomMask alloc] init];
    [_view layer].mask =[mask layer];
    */
    drecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    [drecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:drecognizer];
    urecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    [urecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:urecognizer];
    
	// Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];
}

-(IBAction)endEdit {
    [input resignFirstResponder];
    troll.alpha = 0.0;
    NSString *inputValue = [input text];
    //snippets converters here
    if ([inputValue isEqualToString:@"artofapps"]) {
        [output setText:@"credits"];
    }else if ([inputValue isEqualToString:@"troll"]) {
        troll.alpha = 1.0;
        [output setText:nil];
    } else {
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
    [UIView setAnimationDuration:3.0];
    [[self view] removeGestureRecognizer:urecognizer];
    [[self view] removeGestureRecognizer:drecognizer];
    output.transform = CGAffineTransformMakeTranslation(0.0,140.0);
    troll.transform = CGAffineTransformMakeTranslation(0.0,140.0);
    [UIView commitAnimations];
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
