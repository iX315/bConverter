//
//  bConverterViewController.m
//  bConverter
//
//  Created by Jury Giannelli on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "bConverterViewController.h"

@implementation bConverterViewController

@synthesize infoButton;
@synthesize input;
@synthesize output;
@synthesize glow;
@synthesize troll;
@synthesize urlImage;
@synthesize closed_up;
@synthesize closed_down;
@synthesize inputScroll;
@synthesize outputScroll;
@synthesize pickerView;

@synthesize decelerationRate;

int pageW = 80;
int pageG = 40;
int start = 0;
int iU;
int iD;

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
    
    inputSet = @"DEC";
    outputSet = @"BIN";
    
    inputScroll.decelerationRate = UIScrollViewDecelerationRateFast;
    outputScroll.decelerationRate = UIScrollViewDecelerationRateFast;
    
    self.view.userInteractionEnabled = YES;
    
    [infoButton setImage:[UIImage imageNamed:@"infobutton_.png"] forState:UIControlEventTouchDown];
    
    drecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    [drecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:drecognizer];
    urecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    [urecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:urecognizer];
    
    start++;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    closed_up.transform = CGAffineTransformMakeTranslation(0.0,-200.0);
    closed_down.transform = CGAffineTransformMakeTranslation(0.0,200.0);
    
    if (start == 1) {
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/shutter.caf", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = 0;
        
        if (audioPlayer == nil)
            NSLog(@"%@", error.description);
        else
            [audioPlayer play];
    }
    
    [UIView commitAnimations];
    
    [inputScroll setCanCancelContentTouches:NO];
    inputScroll.clipsToBounds = NO;		// default is NO, we want to restrict drawing within our inputScroll
    inputScroll.scrollEnabled = YES;
    inputScroll.pagingEnabled = NO;
    
    for(int iU=-16; iU<16; iU++)
    {
        if (iU == -16 | iU == -12 | iU == -8 | iU == -4 | iU == 0 | iU == 4 | iU == 8 | iU == 12 | iU == 16) {
            [self addImageWithName:@"button_up_dec.png" atUpPosition:iU];
        }
        if (iU == -15 | iU == -11 | iU == -7 | iU == -3 | iU == 1 | iU == 5 | iU == 9 | iU == 13) {
            [self addImageWithName:@"button_up_bin.png" atUpPosition:iU];
        }
        if (iU == -14 | iU == -10 | iU == -6 | iU == -2 | iU == 2 | iU == 6 | iU == 10 | iU == 14) {
            [self addImageWithName:@"button_up_hex.png" atUpPosition:iU];
        }
        if (iU == -13 | iU == -9 | iU == -5 | iU == -1 | iU == 3 | iU == 7 | iU == 11 | iU == 15) {
            [self addImageWithName:@"button_up_ott.png" atUpPosition:iU];
        }
    }
    
    inputScroll.contentSize = CGSizeMake(pageW*16, 0);    
    [inputScroll setContentOffset:CGPointMake(pageW*3-pageG,0) animated:NO];

    [outputScroll setCanCancelContentTouches:NO];
	outputScroll.clipsToBounds = NO;		// default is NO, we want to restrict drawing within our inputScroll
	outputScroll.scrollEnabled = YES;
	outputScroll.pagingEnabled = NO;
    
    for(int iD=-16; iD<16; iD++)
    {
        if (iD == -16 | iD == -12 | iD == -8 | iD == -4 | iD == 0 | iD == 4 | iD == 8 | iD == 12 | iD == 16) {
            [self addImageWithName:@"buttons_down_dec.png" atDownPosition:iD];
        }
        if (iD == -15 | iD == -11 | iD == -7 | iD == -3 | iD == 1 | iD == 5 | iD == 9 | iD == 13) {
            [self addImageWithName:@"buttons_down_bin.png" atDownPosition:iD];
        }
        if (iD == -14 | iD == -10 | iD == -6 | iD == -2 | iD == 2 | iD == 6 | iD == 10 | iD == 14) {
            [self addImageWithName:@"buttons_down_hex.png" atDownPosition:iD];
        }
        if (iD == -13 | iD == -9 | iD == -5 | iD == -1 | iD == 3 | iD == 7 | iD == 11 | iD == 15) {
            [self addImageWithName:@"buttons_down_ott.png" atDownPosition:iD];
        }
    }
    
    outputScroll.contentSize = CGSizeMake(pageW*16, 0);
    [outputScroll setContentOffset:CGPointMake(pageW*4-pageG,0) animated:NO];
    
    [input setFont:[UIFont fontWithName:@"WW Digital" size:30.0]];
    [output setFont:[UIFont fontWithName:@"WW Digital" size:30.0]];
        
    CALayer *lp= [CALayer layer];
    lp.frame = pickerView.bounds;
    lp.contents = (__bridge id)[[UIImage imageNamed:(@"mask.png")] CGImage];
    pickerView.layer.mask = lp;
} 

#pragma mark - Actions

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

-(IBAction)initEdit {
    [[self view] removeGestureRecognizer:drecognizer];
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
    }else if ([inputValue isEqualToString:@"input"]) {
        [[self view] removeGestureRecognizer:drecognizer];
        [[self view] removeGestureRecognizer:urecognizer];
    } else {
        //check a database of strings mysql on artofapps site
        //if the string exist then:
        if ([inputValue isEqualToString:nil]) {
            //and then set all (urlImage or output)
        } else {
            //else error
            [output setText:@"error"];
        }
        [self conversionDidBeginFrom:inputSet to:outputSet fromValue:inputValue];
    }
    
    self.view.userInteractionEnabled = YES;
    [[self view] addGestureRecognizer:drecognizer];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = output.text;
}

-(void)conversionDidBeginFrom:(inout NSString *)inputSet to:(inout NSString *)outputSet fromValue:(inout NSString *)inputValue {
    
    NSString *inputScrollSet = inputSet;
    NSString *outputScrollSet = outputSet;

{//DEC to ALL
    NSString *errorD = @"error not dec";
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    if ([inputScrollSet isEqualToString:@"DEC"] && [outputScrollSet isEqualToString:@"OTT"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            [output setText:[NSString stringWithFormat:@"%o", inputValue.integerValue]];
            //NSLog(@"DEC to OTT");
        } else {
            [output setText:errorD];
        }
    }
    if ([inputScrollSet isEqualToString:@"DEC"] && [outputScrollSet isEqualToString:@"HEX"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            [output setText:[NSString stringWithFormat:@"%X", inputValue.integerValue]];
            //NSLog(@"DEC to HEX");
        } else {
            [output setText:errorD];
        }
    }
    if ([inputScrollSet isEqualToString:@"DEC"] && [outputScrollSet isEqualToString:@"BIN"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) { 
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
            //NSLog(@"DEC to BIN");
        } else {
            [output setText:errorD];
        }
    }
    if ([inputScrollSet isEqualToString:@"DEC"] && [outputScrollSet isEqualToString:@"DEC"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            [output setText:inputValue];
            //NSLog(@"DEC to DEC");
        } else {
            [output setText:errorD];
        }
    }
}//DEC to ALL

{//OTT to ALL
    NSString *errorO = @"error not oct";
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"012345678"] invertedSet];
    if ([inputScrollSet isEqualToString:@"OTT"] && [outputScrollSet isEqualToString:@"DEC"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            NSString *str = [NSString stringWithFormat:@"%o", inputValue.integerValue];
            [output setText:[NSString stringWithFormat:@"%d", str.integerValue]];
            //NSLog(@"OTT to DEC");
        } else {
            [output setText:errorO];
        }
    }
    if ([inputScrollSet isEqualToString:@"OTT"] && [outputScrollSet isEqualToString:@"HEX"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            NSString *str = [NSString stringWithFormat:@"%o", inputValue.integerValue];
            [output setText:[NSString stringWithFormat:@"%X", str.integerValue]];
            //NSLog(@"OTT to HEX");
        } else {
            [output setText:errorO];
        }
    }
    if ([inputScrollSet isEqualToString:@"OTT"] && [outputScrollSet isEqualToString:@"BIN"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            NSString *strO = [NSString stringWithFormat:@"%o", inputValue.integerValue];
            NSString *strD = [NSString stringWithFormat:@"%d", strO.integerValue];
            NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
            if(strD.integerValue > 0){
                for(NSInteger numberCopy = strD.integerValue; numberCopy > 0; numberCopy >>= 1){	
                    // Prepend "0" or "1", depending on the bit
                    [str insertString:((numberCopy & 1) ? @"1" : @"0") atIndex:0];
                }
            }
            else if(strD.integerValue == 0){
                [str insertString:@"0" atIndex:0];
            }
            [output setText:str];
            //NSLog(@"OTT to BIN");
        } else {
            [output setText:errorO];
        }
    }
    if ([inputScrollSet isEqualToString:@"OTT"] && [outputScrollSet isEqualToString:@"OTT"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            [output setText:inputValue];
            //NSLog(@"OTT to OTT");
        } else {
            [output setText:errorO];
        }
    }
}//OTT to ALL

{//BIN to ALL
    NSString *errorB = @"error not bin";
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"01"] invertedSet];
    
    if ([inputScrollSet isEqualToString:@"BIN"] && [outputScrollSet isEqualToString:@"DEC"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            long v = strtol([inputValue UTF8String], NULL, 2);
            NSString *str = [NSString stringWithFormat:@"%d", v];
            [output setText:str];
        } else {
            [output setText:errorB];
        }
        //NSLog(@"HEX to DEC");
    }
    if ([inputScrollSet isEqualToString:@"BIN"] && [outputScrollSet isEqualToString:@"HEX"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            long v = strtol([inputValue UTF8String], NULL, 2);
            NSString *str = [NSString stringWithFormat:@"%X", v];
            [output setText:str];
        } else {
            [output setText:errorB];
        }
        //NSLog(@"OTT to HEX");
    }
    if ([inputScrollSet isEqualToString:@"BIN"] && [outputScrollSet isEqualToString:@"OTT"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            long v = strtol([inputValue UTF8String], NULL, 2);
            NSString *str = [NSString stringWithFormat:@"%o", v];
            [output setText:str];
        } else {
            [output setText:errorB];
        }
        //NSLog(@"BIN to OTT");
    }
    if ([inputScrollSet isEqualToString:@"BIN"] && [outputScrollSet isEqualToString:@"BIN"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            [output setText:inputValue];
        } else {
            [output setText:errorB];
        }
        //NSLog(@"BIN to BIN");
    }
}//BIN to ALL

{//HEX to ALL
    NSString *errorH = @"error not hex";
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"] invertedSet];
    if ([inputScrollSet isEqualToString:@"HEX"] && [outputScrollSet isEqualToString:@"DEC"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            NSScanner* pScanner = [NSScanner scannerWithString:inputValue];
            unsigned int iValue;
            [pScanner scanHexInt: &iValue];
            NSString *str = [NSString stringWithFormat:@"%d", iValue];
            [output setText:[NSString stringWithFormat:@"%d", str.integerValue]];
            //NSLog(@"HEX to DEC");
        } else {
            [output setText:errorH];
        }
    }
    if ([inputScrollSet isEqualToString:@"HEX"] && [outputScrollSet isEqualToString:@"OTT"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            NSScanner* pScanner = [NSScanner scannerWithString:inputValue];
            unsigned int iValue;
            [pScanner scanHexInt: &iValue];
            NSString *str = [NSString stringWithFormat:@"%d", iValue];
            [output setText:[NSString stringWithFormat:@"%o", str.integerValue]];
            //NSLog(@"HEX to OTT");
        } else {
            [output setText:errorH];
        }
    }
    if ([inputScrollSet isEqualToString:@"HEX"] && [outputScrollSet isEqualToString:@"BIN"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            NSScanner* pScanner = [NSScanner scannerWithString:inputValue];
            unsigned int iValue;
            [pScanner scanHexInt: &iValue];
            NSString *strD = [NSString stringWithFormat:@"%d", iValue];
            NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
            if(strD.integerValue != 0){
                for(NSInteger numberCopy = strD.integerValue; numberCopy > 0; numberCopy >>= 1){	
                    // Prepend "0" or "1", depending on the bit
                    [str insertString:((numberCopy & 1) ? @"1" : @"0") atIndex:0];
                }
            }
            else if(strD.integerValue == 0){
                [str insertString:@"0" atIndex:0];
            }
            [output setText:str];
            //NSLog(@"HEX to BIN");
        } else {
            [output setText:errorH];
        }
    }
    if ([inputScrollSet isEqualToString:@"HEX"] && [outputScrollSet isEqualToString:@"HEX"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            [output setText:inputValue];
            //NSLog(@"HEX to HEX");
        } else {
            [output setText:errorH];
        }
    }
}//HEX to ALL

    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = output.text;
}

#pragma mark - Animations

-(void)handleSwipeDown:(UISwipeGestureRecognizerDirection *)sender {
    ////NSLog(@"Swipe received.");
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(animation_end:) userInfo:nil repeats:NO];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    input.transform = CGAffineTransformMakeTranslation(0.0,140.0);        
    [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(alpha_on:) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(alpha_back:) userInfo:nil repeats:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    self.view.userInteractionEnabled = NO;
    output.transform = CGAffineTransformMakeTranslation(0.0,140.0);
    troll.transform = CGAffineTransformMakeTranslation(0.0,140.0);
    urlImage.transform = CGAffineTransformMakeTranslation(0.0,140.0);
    [UIView commitAnimations];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/swipe.caf", [[NSBundle mainBundle] resourcePath]]];
    
    [[self view] removeGestureRecognizer:drecognizer];
    [[self view] addGestureRecognizer:urecognizer];
	
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
    urlImage.transform = CGAffineTransformMakeTranslation(0.0,0.0);
    [UIView commitAnimations];
            
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    self.view.userInteractionEnabled = NO;
    input.userInteractionEnabled = NO;
    input.transform = CGAffineTransformMakeTranslation(0.0,0.0);
    [UIView commitAnimations];
    
    [[self view] removeGestureRecognizer:urecognizer];
    [[self view] addGestureRecognizer:drecognizer];

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
    input.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
}

#pragma mark - UI

- (void)addImageWithName:(NSString*)imageString atUpPosition:(int)position {
	// add image to scroll view
	UIImage *image = [UIImage imageNamed:imageString];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = CGRectMake(position*80, 0, 80, 86);
	[inputScroll addSubview:imageView];
}

- (void)addImageWithName:(NSString*)imageString atDownPosition:(int)position {
	// add image to scroll view
	UIImage *imageDown = [UIImage imageNamed:imageString];
	UIImageView *imageDownView = [[UIImageView alloc] initWithImage:imageDown];
	imageDownView.frame = CGRectMake(position*80, 0, 80, 86);
	[outputScroll addSubview:imageDownView];
}


//////////////////////////////////////////

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.view.userInteractionEnabled = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //NSLog(@"offset, %f", targetContentOffset->x);
    float index = targetContentOffset->x/pageW;
    NSString *offsetI = [NSString stringWithFormat:@"%f", index];
    NSLog(@"index, %i", offsetI.integerValue);
    
    //1st HEX
{
    if (offsetI.integerValue == 0) {
        *targetContentOffset = CGPointMake(pageW*1-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"HEX";
        } else {
            outputSet = @"HEX";
        }
    }
    if (offsetI.integerValue == 4) {
        *targetContentOffset = CGPointMake(pageW*5-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"HEX";
        } else {
            outputSet = @"HEX";
        }
    }
    if (offsetI.integerValue == 8) {
        *targetContentOffset = CGPointMake(pageW*9-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"HEX";
        } else {
            outputSet = @"HEX";
        }
    }
    if (offsetI.integerValue == 12) {
        *targetContentOffset = CGPointMake(pageW*13-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"HEX";
        } else {
            outputSet = @"HEX";
        }
    }
}
    //2nd OTT
{
    if (offsetI.integerValue == 1) {
        *targetContentOffset = CGPointMake(pageW*2-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"OTT";
        } else {
            outputSet = @"OTT";
        }
    }
    if (offsetI.integerValue == 5) {
        *targetContentOffset = CGPointMake(pageW*6-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"OTT";
        } else {
            outputSet = @"OTT";
        }
    }
    if (offsetI.integerValue == 9) {
        *targetContentOffset = CGPointMake(pageW*10-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"OTT";
        } else {
            outputSet = @"OTT";
        }
    }
}
    //3th DEC
{
    if (offsetI.integerValue == 2) {
        *targetContentOffset = CGPointMake(pageW*3-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"DEC";
        } else {
            outputSet = @"DEC";
        }
    }
    if (offsetI.integerValue == 6) {
        *targetContentOffset = CGPointMake(pageW*7-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"DEC";
        } else {
            outputSet = @"DEC";
        }
    }
    if (offsetI.integerValue == 10) {
        *targetContentOffset = CGPointMake(pageW*11-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"DEC";
        } else {
            outputSet = @"DEC";
        }
    }
}
    //4th BIN
{
    if (offsetI.integerValue == 3) {
        *targetContentOffset = CGPointMake(pageW*4-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"BIN";
        } else {
            outputSet = @"BIN";
        }
    }
    if (offsetI.integerValue == 7) {
        *targetContentOffset = CGPointMake(pageW*8-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"BIN";
        } else {
            outputSet = @"BIN";
        }
    }
    if (offsetI.integerValue == 11) {
        *targetContentOffset = CGPointMake(pageW*12-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"BIN";
        } else {
            outputSet = @"BIN";
        }
    }
}
    
    self.view.userInteractionEnabled = YES;
    [self endEdit];
    [[self view] removeGestureRecognizer:drecognizer];
    [[self view] addGestureRecognizer:urecognizer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == pageG)
        [scrollView setContentOffset:CGPointMake(pageW*5-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*6-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW*2+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*7-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW*3+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*8-pageG,0) animated:NO];

    if (scrollView.contentOffset.x == pageW*8+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*5-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW*9+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*6-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW*10+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*7-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW*11+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*8-pageG,0) animated:NO];
    
}

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
