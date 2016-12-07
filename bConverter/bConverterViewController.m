//
//  bConverterViewController.m
//  bConverter
//
//  Created by Jury Giannelli on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "bConverterViewController.h"
#import <Twitter/Twitter.h>

static NSString* kAppId = @"335077529891696";
#define CONST_APP_LINK @"http://www.artofapps.net/redirect/BConverter.php"

@implementation bConverterViewController

@synthesize infoButton, input, output, glow, troll, urlImage, closed_up, closed_down, inputScroll, outputScroll, pickerView, fb, tw;

@synthesize decelerationRate;
@synthesize facebook = _facebook;

int pageW = 80;
int pageG = 40;
int start = 0;
int iU;
int iD;

bool isConverted = NO;

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
    
    //facebook - start load
    txtPostMessage.clipsToBounds = YES;
    txtPostMessage.contentInset = UIEdgeInsetsZero;
    
    [self HideFacebookDialog];
    
    //viewPostOnFacebook.backgroundColor = [UIColor clearColor];
    txtPostMessage.backgroundColor = [UIColor clearColor];
    viewPostOnFacebook.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"facebookshare_overlay"]];
    
	_permissions =  [NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access",nil];
	//facebook - end load

    inputSet = @"OTT";
    outputSet = @"STR";
    
    inputScroll.decelerationRate = UIScrollViewDecelerationRateFast;
    outputScroll.decelerationRate = UIScrollViewDecelerationRateFast;
    
    self.view.userInteractionEnabled = YES;
    
    [infoButton setImage:[UIImage imageNamed:@"infobutton_.png"] forState:UIControlEventTouchDown];
    [fb setImage:[UIImage imageNamed:@"fb_p.png"] forState:UIControlEventTouchDown];
    [tw setImage:[UIImage imageNamed:@"tw_p.png"] forState:UIControlEventTouchDown];
    
    //accelerometer = [UIAccelerometer sharedAccelerometer];
    //accelerometer.delegate = self;
    
    drecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    [drecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:drecognizer];
    urecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    [urecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:urecognizer];
    
    //rrecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    //[rrecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:drecognizer];
    //lrecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    //[lrecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:urecognizer];
    
    start++;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    closed_up.transform = CGAffineTransformMakeTranslation(0.0,-200.0);
    closed_down.transform = CGAffineTransformMakeTranslation(0.0,200.0);
    //fb.alpha = 0.0;
    //tw.alpha = 0.0;
    
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
    
    for(int iU=-20; iU<20; iU++)
    {
        if (iU == -20 | iU == -15 | iU == -10 | iU == -5 | iU == 0 | iU == 5 | iU == 10 | iU == 15 | iU == 20) {
            [self addImageWithName:@"button_up_ascii.png" atUpPosition:iU];
        }
        if (iU == -19 | iU == -14 | iU == -9 | iU == -4 | iU == 1 | iU == 6 | iU == 11 | iU == 16) {
            [self addImageWithName:@"button_up_dec.png" atUpPosition:iU];
        }
        if (iU == -18 | iU == -13 | iU == -8 | iU == -3 | iU == 2 | iU == 7 | iU == 12 | iU == 17) {
            [self addImageWithName:@"button_up_bin.png" atUpPosition:iU];
        }
        if (iU == -17 | iU == -12 | iU == -7 | iU == -2 | iU == 3 | iU == 8 | iU == 13 | iU == 18) {
            [self addImageWithName:@"button_up_hex.png" atUpPosition:iU];
        }
        if (iU == -16 | iU == -11 | iU == -6 | iU == -1 | iU == 4 | iU == 9 | iU == 14 | iU == 19) {
            [self addImageWithName:@"button_up_ott.png" atUpPosition:iU];
        }
    }
    
    inputScroll.contentSize = CGSizeMake(pageW*16, 0);    
    [inputScroll setContentOffset:CGPointMake(pageW*3-pageG,0) animated:NO];

    [outputScroll setCanCancelContentTouches:NO];
	outputScroll.clipsToBounds = NO;		// default is NO, we want to restrict drawing within our inputScroll
	outputScroll.scrollEnabled = YES;
	outputScroll.pagingEnabled = NO;
    
    for(int iD=-20; iD<20; iD++)
    {
        if (iD == -20 | iD == -15 | iD == -10 | iD == -5 | iD == 0 | iD == 5 | iD == 10 | iD == 15 | iD == 20) {
            [self addImageWithName:@"buttons_down_ascii.png" atDownPosition:iD];
        }
        if (iD == -19 | iD == -14 | iD == -9 | iD == -4 | iD == 1 | iD == 6 | iD == 11 | iD == 16) {
            [self addImageWithName:@"buttons_down_dec.png" atDownPosition:iD];
        }
        if (iD == -18 | iD == -13 | iD == -8 | iD == -3 | iD == 2 | iD == 7 | iD == 12 | iD == 17) {
            [self addImageWithName:@"buttons_down_bin.png" atDownPosition:iD];
        }
        if (iD == -17 | iD == -12 | iD == -7 | iD == -2 | iD == 3 | iD == 8 | iD == 13 | iD == 18) {
            [self addImageWithName:@"buttons_down_hex.png" atDownPosition:iD];
        }
        if (iD == -16 | iD == -11 | iD == -6 | iD == -1 | iD == 4 | iD == 9 | iD == 14 | iD == 19) {
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

- (void)settingsViewControllerDidFinish:(FlipsideViewController *)controller
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
    if ([inputValue isEqualToString:@"ARTOFAPPS"]) {
        [output setText:@"credits"];
    }else if ([inputValue isEqualToString:@"TROLL"]) {
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
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *autoCopy = [ud stringForKey:@"autoCopy"];
    if ([autoCopy  isEqual: @"1"]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = output.text;
    }
}

-(void)conversionDidBeginFrom:(inout NSString *)inputSet to:(inout NSString *)outputSet fromValue:(inout NSString *)inputValue {
    
    inputScrollSet = inputSet;
    outputScrollSet = outputSet;
    NSArray *inputValues = [inputValue componentsSeparatedByString:@"&"];
    NSMutableString *str = [[NSMutableString alloc] initWithString:@""];

{//DEC to ALL
    NSString *errorD = @"error not dec";
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789&"] invertedSet];
    if ([inputScrollSet isEqualToString:@"DEC"] && [outputScrollSet isEqualToString:@"OTT"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in inputValues) {
                [str appendFormat:@"%o",val.integerValue];
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
            //NSLog(@"DEC to OTT");
        } else {
            [output setText:errorD];
        }
    }
    if ([inputScrollSet isEqualToString:@"DEC"] && [outputScrollSet isEqualToString:@"HEX"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in inputValues) {
                [str appendFormat:@"%X",val.integerValue];
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
            //NSLog(@"DEC to HEX");
        } else {
            [output setText:errorD];
        }
    }
    if ([inputScrollSet isEqualToString:@"DEC"] && [outputScrollSet isEqualToString:@"STR"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in inputValues) {
                [str appendFormat:@"%C",val.integerValue];
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
            //NSLog(@"DEC to STR");
        } else {
            [output setText:errorD];
        }
    }
    if ([inputScrollSet isEqualToString:@"DEC"] && [outputScrollSet isEqualToString:@"BIN"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) { 
            int i = 0;
            for (NSString *val in inputValues) {
                if(val.integerValue > 0){
                    for(NSInteger numberCopy = val.integerValue; numberCopy > 0; numberCopy >>= 1){	
                        // Prepend "0" or "1", depending on the bit
                        [str appendFormat:((numberCopy & 1) ? @"1" : @"0")];
                    }
                }
                else if(val.integerValue == 0){
                    [str appendFormat:@"0"];
                }
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
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
    NSMutableArray *octValues = [[NSMutableArray alloc] init];
    for (NSString *value in inputValues) {
        int r,s=0,i;
        int n = value.integerValue;
        for(i=0;n!=0;i++)
        {
            r=n%10;
            s=s+r*(int)pow(8,i);
            n=n/10;
        }
        NSString *octVal = [NSString stringWithFormat:@"%d",s];
        [octValues addObject:octVal];
    }
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"01234567&"] invertedSet];
    if ([inputScrollSet isEqualToString:@"OTT"] && [outputScrollSet isEqualToString:@"DEC"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in octValues) {
                [str appendFormat:@"%d",val.integerValue];
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
            //NSLog(@"OTT to DEC");
        } else {
            [output setText:errorO];
        }
    }
    if ([inputScrollSet isEqualToString:@"OTT"] && [outputScrollSet isEqualToString:@"HEX"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in octValues) {
                [str appendFormat:@"%X",val.integerValue];
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
            //NSLog(@"OTT to HEX");
        } else {
            [output setText:errorO];
        }
    }
    if ([inputScrollSet isEqualToString:@"OTT"] && [outputScrollSet isEqualToString:@"BIN"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in octValues) {
                if(val.integerValue > 0){
                    for(NSInteger numberCopy = val.integerValue; numberCopy > 0; numberCopy >>= 1){	
                        // Prepend "0" or "1", depending on the bit
                        [str insertString:((numberCopy & 1) ? @"1" : @"0") atIndex:0];
                    }
                }
                else if(val.integerValue == 0){
                    [str insertString:@"0" atIndex:0];
                }
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
            //NSLog(@"OTT to BIN");
        } else {
            [output setText:errorO];
        }
    }
    if ([inputScrollSet isEqualToString:@"OTT"] && [outputScrollSet isEqualToString:@"STR"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in octValues) {
                NSArray *inputValues = [val componentsSeparatedByString:@"&"];
                NSLog(@"%@",inputValues);
                for (NSString *line in inputValues) {
                    [str appendFormat:@"%C",line.integerValue];
                    i++;
                    if (i < inputValues.count) {
                        [str appendFormat:@"&"];
                    }
                }
            }
            [output setText:[NSString stringWithFormat:@"%@", str]];
            //NSLog(@"OTT to STR");
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
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"01&"] invertedSet];
    
    if ([inputScrollSet isEqualToString:@"BIN"] && [outputScrollSet isEqualToString:@"DEC"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in inputValues) {
                long v = strtol([val UTF8String], NULL, 2);
                [str appendFormat:@"%d", v];
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
        } else {
            [output setText:errorB];
        }
        //NSLog(@"HEX to DEC");
    }
    if ([inputScrollSet isEqualToString:@"BIN"] && [outputScrollSet isEqualToString:@"HEX"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in inputValues) {
                long v = strtol([val UTF8String], NULL, 2);
                [str appendFormat:@"%X", v];
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
        } else {
            [output setText:errorB];
        }
        //NSLog(@"OTT to HEX");
    }
    if ([inputScrollSet isEqualToString:@"BIN"] && [outputScrollSet isEqualToString:@"OTT"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in inputValues) {
                long v = strtol([val UTF8String], NULL, 2);
                [str appendFormat:@"%o", v];
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
        } else {
            [output setText:errorB];
        }
        //NSLog(@"BIN to OTT");
    }
    if ([inputScrollSet isEqualToString:@"BIN"] && [outputScrollSet isEqualToString:@"STR"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in inputValues) {
                long v = strtol([val UTF8String], NULL, 2);
                NSScanner* pScanner = [NSScanner scannerWithString:[NSString stringWithFormat:@"%d",v]];
                unsigned int iValue;
                [pScanner scanHexInt: &iValue];
                [str appendFormat:@"%c", iValue];
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
            //NSLog(@"BIN to STR");
        } else {
            [output setText:errorB];
        }
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
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF&"] invertedSet];
    if ([inputScrollSet isEqualToString:@"HEX"] && [outputScrollSet isEqualToString:@"DEC"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in inputValues) {
                NSScanner* pScanner = [NSScanner scannerWithString:val];
                unsigned int iVal;
                [pScanner scanHexInt: &iVal];
                [str appendFormat:@"%d", iVal];
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
            //NSLog(@"HEX to DEC");
        } else {
            [output setText:errorH];
        }
    }
    if ([inputScrollSet isEqualToString:@"HEX"] && [outputScrollSet isEqualToString:@"OTT"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in inputValues) {
                NSScanner* pScanner = [NSScanner scannerWithString:val];
                unsigned int iVal;
                [pScanner scanHexInt: &iVal];
                [str appendFormat:@"%o", iVal];
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
            //NSLog(@"HEX to OTT");
        } else {
            [output setText:errorH];
        }
    }
    if ([inputScrollSet isEqualToString:@"HEX"] && [outputScrollSet isEqualToString:@"BIN"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in inputValues) {
                NSScanner* pScanner = [NSScanner scannerWithString:val];
                unsigned int iVal;
                [pScanner scanHexInt: &iVal];
                NSString *strD = [NSString stringWithFormat:@"%d", iVal];
                if(strD.integerValue != 0){
                    for(NSInteger numberCopy = strD.integerValue; numberCopy > 0; numberCopy >>= 1){	
                        // Prepend "0" or "1", depending on the bit
                        [str appendFormat:((numberCopy & 1) ? @"1" : @"0")];
                    }
                }
                else if(strD.integerValue == 0){
                    [str appendFormat:@"0"];
                }
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
            //NSLog(@"HEX to BIN");
        } else {
            [output setText:errorH];
        }
    }
    if ([inputScrollSet isEqualToString:@"HEX"] && [outputScrollSet isEqualToString:@"STR"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in inputValues) {
                //NSScanner* pScanner = [NSScanner scannerWithString:val];
                //unsigned int iVal;
                //[pScanner scanHexInt: &iVal];
                //while ([pScanner scanHexInt: &iVal]) {
                    //NSLog(@"%c",iVal);
                    //[str appendFormat:@"%c",(char)(iVal & 0xFF)];
                [str appendFormat:@"%c",val];
                //}
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
            //NSLog(@"HEX to STR");
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
    
{//STR to ALL
        NSString *errorH = @"error not char";
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890&"] invertedSet];
        if ([inputScrollSet isEqualToString:@"STR"] && [outputScrollSet isEqualToString:@"DEC"]) {
            if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
                int i = 0;
                for (NSString *val in inputValues) {
                    NSScanner* pScanner = [NSScanner scannerWithString:val];
                    NSString *iValue;
                    [pScanner scanString:val intoString:&iValue];
                    NSString *tmp = [self bitsForString:iValue];
                    long v = strtol([tmp UTF8String], NULL, 2);
                    [str appendFormat:[NSString stringWithFormat:@"%d", v]];
                    i++;
                    if (i < inputValues.count) {
                        [str appendFormat:@"&"];
                    }
                }
                [output setText:str];
                //NSLog(@"STR to DEC");
            } else {
                [output setText:errorH];
            }
        }
        if ([inputScrollSet isEqualToString:@"STR"] && [outputScrollSet isEqualToString:@"OTT"]) {
            if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
                int i = 0;
                for (NSString *val in inputValues) {
                    NSScanner* pScanner = [NSScanner scannerWithString:val];
                    NSString *iValue;
                    [pScanner scanString:val intoString:&iValue];
                    NSString *tmp = [self bitsForString:iValue];
                    long v = strtol([tmp UTF8String], NULL, 2);
                    [str appendFormat:[NSString stringWithFormat:@"%o", v]];
                    i++;
                    if (i < inputValues.count) {
                        [str appendFormat:@"&"];
                    }
                }
                [output setText:str];
                //NSLog(@"STR to OTT");
            } else {
                [output setText:errorH];
            }
        }
        if ([inputScrollSet isEqualToString:@"STR"] && [outputScrollSet isEqualToString:@"BIN"]) {
            if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
                int i = 0;
                for (NSString *val in inputValues) {
                    NSScanner* pScanner = [NSScanner scannerWithString:val];
                    NSString *iValue;
                    [pScanner scanString:val intoString:&iValue];
                    NSString *tmp = [self bitsForString:iValue];
                    [str appendFormat:tmp];
                    i++;
                    if (i < inputValues.count) {
                        [str appendFormat:@"&"];
                    }
                }
                [output setText:str];
                //NSLog(@"STR to BIN");
            } else {
                [output setText:errorH];
            }  
        }
    if ([inputScrollSet isEqualToString:@"STR"] && [outputScrollSet isEqualToString:@"HEX"]) {
        if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
            int i = 0;
            for (NSString *val in inputValues) {
                NSScanner* pScanner = [NSScanner scannerWithString:val];
                NSString *iValue;
                [pScanner scanString:val intoString:&iValue];
                NSString *tmp = [self bitsForString:iValue];
                long v = strtol([tmp UTF8String], NULL, 2);
                [str appendFormat:[NSString stringWithFormat:@"%X", v]];
                i++;
                if (i < inputValues.count) {
                    [str appendFormat:@"&"];
                }
            }
            [output setText:str];
            //NSLog(@"STR to HEX");
        } else {
            [output setText:errorH];
        }
    }
        if ([inputScrollSet isEqualToString:@"STR"] && [outputScrollSet isEqualToString:@"STR"]) {
            if ([inputValue rangeOfCharacterFromSet:characterSet].location == NSNotFound) {
                [output setText:inputValue];
                //NSLog(@"STR to STR");
            } else {
                [output setText:errorH];
            }
        }
}//STR to ALL
}

- (NSString *)bits:(NSInteger)value forSize:(int)size {
    const int shift = 8*size - 1;
    const unsigned mask = 1 << shift;
    NSMutableString *result = [NSMutableString string];
    for (int i = 1; i <= shift + 1; i++ ) {
        [result appendString:(value & mask ? @"1" : @"0")];
        value <<= 1;
        if (i % 8 == 0) {
            [result appendString:@""];
        }
    }
    return result;
}

- (NSString *)bitsForInteger:(NSInteger)value {
    return [self bits:value forSize:sizeof(NSInteger)];
}

- (NSString *)bitsForString:(NSString *)value {
    const char *cString = [value UTF8String];
    int length = strlen(cString);
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < length; i++) {
        [result appendString:[self bits:*cString++ forSize:sizeof(char)]];
    }
    return result;
}

#pragma mark - ShareButtons

-(IBAction)ShareAppViaTwitter:(id)sender
{
    NSString *message = [self GetTwitterPost];
    
    //message = @"boh";
    
    /*NSString *message = @"";   
     message = [self Concat:message with:@"Hi guys! I am using iDrinkWater for iPhone. It's FREE and it will help you for a better health."];
     message = [self Concat:message with:NSLocalizedString(@"Shared via @iDrinkWater for iPhone",@"")];
     message = [self Concat:message with:@" - "];
     message = [self Concat:message with:CONST_APP_LINK];*/
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setCompletionHandler:^(TWTweetComposeViewControllerResult result)
     {
         //UIAlertView *v; 
         switch (result) {
             case TWTweetComposeViewControllerResultDone:
                 /*v= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tweet sent!",@"") message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok",@""), nil];
                  [v show];
                  [v release];*/
                 break;
                 
             case TWTweetComposeViewControllerResultCancelled:
                 //annullato
                 break;
                 
             default:
                 break;
         }
         [self dismissModalViewControllerAnimated:YES];
     }
     ];
    //[twitter addURL:[NSURL URLWithString:@"http://www.artofapps.net/redirect/Smoky.php"]];
    [twitter setInitialText:message]; 
    [self presentModalViewController:twitter animated:YES];
    
}

#pragma mark - Animations
/*
-(void)handleSwipeRight:(UISwipeGestureRecognizerDirection *)sender {
    //NSLog(@"Swipe received. -->");
    if (tw.alpha == 1.0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        tw.alpha = 0.0;
        tw.userInteractionEnabled = NO;
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        tw.alpha = 1.0;
        tw.userInteractionEnabled = YES;
        [UIView commitAnimations];
    }    
}

-(void)handleSwipeLeft:(UISwipeGestureRecognizerDirection *)sender {
    //NSLog(@"Swipe received. <--");
    if (fb.alpha == 1.0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        fb.alpha = 0.0;
        fb.userInteractionEnabled = NO;
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        fb.alpha = 1.0;
        fb.userInteractionEnabled = YES;
        [UIView commitAnimations];
    }
}
*/

-(void)accelerometer:(CMAcceleration *)accelerometer didAccelerate:(CMAcceleration *)acceleration {
    if (acceleration->y < -1.5) {
        NSLog(@"DOWN");
    }
    if (acceleration->y > 0.5) {
        NSLog(@"UP");
    }
    //NSLog(@"%f",acceleration.y);
}

//-(void)timer:(NSTimer)

-(void)handleSwipeDown:(UISwipeGestureRecognizerDirection *)sender {
    ////NSLog(@"Swipe received. v");
    
    isConverted = YES;
    
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
    //[[self view] addGestureRecognizer:rrecognizer];
    //[[self view] addGestureRecognizer:lrecognizer];
	
    NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = 0;
    
	if (audioPlayer == nil)
		NSLog(@"%@", error.description);
	else
		[audioPlayer play];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = output.text;
}

-(void)handleSwipeUp:(UISwipeGestureRecognizerDirection *)sender {
    //NSLog(@"Swipe received. ^");
    
    isConverted = NO;
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
    //[[self view] removeGestureRecognizer:rrecognizer];
    //[[self view] removeGestureRecognizer:lrecognizer];
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
    //NSLog(@"index, %i", offsetI.integerValue);
    
    //BIN
{
    if (offsetI.integerValue == 0) {
        *targetContentOffset = CGPointMake(pageW*1-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"BIN";
        } else {
            outputSet = @"BIN";
        }
    }
    if (offsetI.integerValue == 5) {
        *targetContentOffset = CGPointMake(pageW*6-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"BIN";
        } else {
            outputSet = @"BIN";
        }
    }
    if (offsetI.integerValue == 10) {
        *targetContentOffset = CGPointMake(pageW*11-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"BIN";
        } else {
            outputSet = @"BIN";
        }
    }
}
    //HEX
{
    if (offsetI.integerValue == 1) {
        *targetContentOffset = CGPointMake(pageW*2-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"HEX";
        } else {
            outputSet = @"HEX";
        }
    }
    if (offsetI.integerValue == 6) {
        *targetContentOffset = CGPointMake(pageW*7-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"HEX";
        } else {
            outputSet = @"HEX";
        }
    }
    if (offsetI.integerValue == 11) {
        *targetContentOffset = CGPointMake(pageW*12-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"HEX";
        } else {
            outputSet = @"HEX";
        }
    }
}
    //OTT
{
    if (offsetI.integerValue == 2) {
        *targetContentOffset = CGPointMake(pageW*3-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"OTT";
        } else {
            outputSet = @"OTT";
        }
    }
    if (offsetI.integerValue == 7) {
        *targetContentOffset = CGPointMake(pageW*8-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"OTT";
        } else {
            outputSet = @"OTT";
        }
    }
    if (offsetI.integerValue == 12) {
        *targetContentOffset = CGPointMake(pageW*13-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"OTT";
        } else {
            outputSet = @"OTT";
        }
    }
}
    //STR
{
    if (offsetI.integerValue == 3) {
        *targetContentOffset = CGPointMake(pageW*4-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"STR";
        } else {
            outputSet = @"STR";
        }
    }
    if (offsetI.integerValue == 8) {
        *targetContentOffset = CGPointMake(pageW*9-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"STR";
        } else {
            outputSet = @"STR";
        }
    }
    if (offsetI.integerValue == 13) {
        *targetContentOffset = CGPointMake(pageW*14-pageG, 0);
        if (scrollView.tag == 1) {
            inputSet = @"STR";
        } else {
            outputSet = @"STR";
        }
    }
}
    //DEC
{
    if (offsetI.integerValue == 4) {
        *targetContentOffset = CGPointMake(pageW*5-pageG, 0);
        if (scrollView.tag == 1) {
                inputSet = @"DEC";
            } else {
                outputSet = @"DEC";
            }
        }
        if (offsetI.integerValue == 9) {
            *targetContentOffset = CGPointMake(pageW*10-pageG, 0);
            if (scrollView.tag == 1) {
                inputSet = @"DEC";
            } else {
                outputSet = @"DEC";
            }
        }
        if (offsetI.integerValue == 14) {
            *targetContentOffset = CGPointMake(pageW*15-pageG, 0);
            if (scrollView.tag == 1) {
                inputSet = @"DEC";
            } else {
                outputSet = @"DEC";
            }
        }
}
    
    self.view.userInteractionEnabled = YES;
    [self endEdit];
    if (isConverted == YES) {
        [[self view] removeGestureRecognizer:drecognizer];
        [[self view] addGestureRecognizer:urecognizer];
    } else {
        [[self view] addGestureRecognizer:drecognizer];
        [[self view] removeGestureRecognizer:urecognizer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == pageG)
        [scrollView setContentOffset:CGPointMake(pageW*6-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*7-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW*2+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*8-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW*3+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*9-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW*4+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*10-pageG,0) animated:NO];
    
    if (scrollView.contentOffset.x == pageW*11+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*7-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW*12+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*8-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW*13+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*9-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW*14+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*10-pageG,0) animated:NO];
    if (scrollView.contentOffset.x == pageW*15+pageG)
        [scrollView setContentOffset:CGPointMake(pageW*11-pageG,0) animated:NO];
    
}

//////////////////////////////////////////


#pragma mark - Others

-(NSString *)Concat:(NSString *)s1 with:(NSString *)s2
{
	return [self Concat:s1 with:s2 withSpace:false];
}

-(NSString *)Concat:(NSString *)s1 with:(NSString *)s2 withSpace:(BOOL)withSpace
{
	NSMutableString *ms = [NSMutableString string];
    [ms appendString:s1];
    if(withSpace) [ms appendString:@" "];
    [ms appendString:s2];
	return ms;
}

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

-(IBAction)ShareAppViaFacebook:(id)sender
{
    [self DoLogin];
}

-(void)fbDidLogin
{
    [[NSUserDefaults standardUserDefaults] setObject:_facebook.accessToken forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:_facebook.expirationDate forKey:@"ExpirationDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /*UIButton * btnPost = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     btnPost.frame = CGRectMake(100, 150, 70, 30);
     [btnPost setTitle:@"Post" forState:UIControlStateNormal];
     [btnPost addTarget:self action:@selector(publishStream:) forControlEvents:UIControlEventTouchDown];
     [self.view addSubview:btnPost];*/
    
    /*UIButton * btnUpload = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     btnUpload.frame = CGRectMake(100, 200, 70, 30);
     [btnUpload setTitle:@"Upload" forState:UIControlStateNormal];
     [btnUpload addTarget:self action:@selector(uploadFoto:) forControlEvents:UIControlEventTouchDown];
     [self.view addSubview:btnUpload];*/
    
    
    [self ShowFacebookDialog];
}

-(NSString *)GetFacebookPost
{
    NSString *message = NSLocalizedString(@"FACEBOOK_TEXT", @"") ;
    message = [self Concat:message with:@" "];
    message = [self Concat:message with:CONST_APP_LINK];
	return message;
}

-(NSString *)GetTwitterPost
{
    NSString *message = NSLocalizedString(@"TWITTER_TEXT", @"") ;
    message = [self Concat:message with:@" "];
    message = [self Concat:message with:CONST_APP_LINK];
    NSLog(@"tweet = %@", message);
	return message;
}

-(void)ShowFacebookDialog
{
    txtPostMessage.text = [self GetFacebookPost];
    viewPostOnFacebook.hidden=false;
    [txtPostMessage becomeFirstResponder];
}
-(void)HideFacebookDialog
{
    [txtPostMessage resignFirstResponder];
    viewPostOnFacebook.hidden=true;
}

-(void)publishStream:(id)sender
{
    /*SBJSON *jsonWriter = [[SBJSON new] autorelease];
     
     //link del post
     NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys: 
     NSLocalizedString(CONST_APP_NAME, @""),@"text", //nome link
     CONST_APP_LINK,@"href", //collegamento link
     nil], nil];
     
     
     NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
     */
    //immmagine post
	/*NSDictionary* media = [NSDictionary dictionaryWithObjectsAndKeys:
     @"image", @"type", //tipo di media allegato (immagine)
     @"http://www.devapp.it/wordpress/wp-content/uploads/logo_devAPP.png", @"src", //link dell'immagine
     @"http://www.devapp.it/", @"href", nil]; //link a cui porta l'immagine se cliccata
     NSArray * arraymedia = [NSArray arrayWithObject:media];*/
    
    
    
	/*//collegamenti dell'immagine del post
     NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
     @"devAPP", @"name", //nome che compare vicino all'immagine
     arraymedia, @"media",
     @"Tramite devAPP.it per iphone", @"caption", //caption (parte in piccolo sotto l'iconcina della nostra app
     @"http://www.devapp.it/", @"href", nil];//link a cui posrta caption
     
     NSString *attachmentStr = [jsonWriter stringWithObject:attachment];*/
    
    
    //parametri post
	/*NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     kAppId, @"api_key", //chiave api
     @"Share on Facebook",  @"user_message_prompt", //default. Si può modificare ma non ha rilievo per il post
     @"Post from HowMuchCigarettes", @"message", //messaggio di post (è l'unica cosa che l'utente può modificare prima del post)
     actionLinksStr, @"action_links",
     //nil,//attachmentStr, @"attachment",
     nil];*/
    
    /*NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"My test app", @"name",
     @"http://www.google.com", @"link",
     @"", @"caption", //FBTestApp app for iPhone!
     @"This is a description of my app", @"description",
     @"Hello!\n\nThis is a test message\nfrom my test iPhone app!", @"message",              
     nil];*/
    
    
	//message = [self Concat:message with:@"\n"];
	//message = [self Concat:message with:NSLocalizedString(@"Shared via @Smoky for iPhone",@"")];
	//message = [self Concat:message with:@" - "];
	//message = [self Concat:message with:@"<A HREF=""http://itunes.apple.com/it/app/bconverter/id489811376?mt=8""></A>"];
    NSMutableDictionary *params = [NSMutableDictionary  dictionaryWithObjectsAndKeys:
                                   txtPostMessage.text, @"message",
                                   //@"My new status message", @"message",
                                   nil];
    
    //[self showMsgBox:message];
    // Publish.
    // This is the most important method that you call. It does the actual job, the message posting.
    [_facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
	/*[_facebook dialog: @"stream.publish"
     andParams: params
     andDelegate:self]; */
    [self HideFacebookDialog];
}

-(void)uploadFoto:(id)sender
{
    NSString *path = @"http://www.devapp.it/wordpress/wp-content/uploads/logo_devAPP.png";
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img  = [[UIImage alloc] initWithData:data];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   img, @"picture",
                                   nil];
    
    [_facebook requestWithGraphPath:@"me/photos"
                          andParams:params
                      andHttpMethod:@"POST"
                        andDelegate:self];
    
    //[img release];
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    //[self showMsgBox: NSLocalizedString(@"did load",@"")];
    //[self ShowFacebookDialog];
}
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    [self HideFacebookDialog];
    NSString *title = NSLocalizedString(@"Unable to post on Facebook.","");
    NSString *msg = @"";
    msg = [self Concat:msg with:NSLocalizedString(@"The post","")];
    msg = [self Concat:msg with:@" '"];
    msg = [self Concat:msg with:[self GetFacebookPost]];
    msg = [self Concat:msg with:@"' "];
    msg = [self Concat:msg with:NSLocalizedString(@"cannot be sent because the connection to Facebook failed.","")];
    [self showMsgBox:msg withTitle:title cancelButtonText:NSLocalizedString(@"Cancel","") otherButtonText:NSLocalizedString(@"Retry","")];
}
- (void)dialogDidComplete:(FBDialog *)dialog
{
    NSLog(@"- (void)dialogDidComplete:(FBDialog *)dialog");    
    
}
- (void)fbSessionInvalidated;
{
    NSLog(@"- (void)fbSessionInvalidated;");    
}
- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt
{
    NSLog(@"- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt");    
}
- (void)fbDidNotLogin:(BOOL)cancelled
{
    NSLog(@"- (void)fbDidNotLogin:(BOOL)cancelled");    
}
- (void)fbDidLogout
{
    NSLog(@"- (void)fbDidLogout");    
}-(void)loginToFacebook:(id)sender
{
    [self DoLogin];
}
-(void)DoLogin
{
    //Chiave API = 392620450748844
    
    //_facebook = [[[Facebook alloc] initWithAppId:kAppId andDelegate:self] retain];
    _facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    
    _facebook.accessToken    = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessToken"];
    _facebook.expirationDate = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey:@"ExpirationDate"];
    
    if (![_facebook isSessionValid]) {
        [_facebook authorize:_permissions];
    }
    else {
        [_facebook requestWithGraphPath:@"me" andDelegate:self];
        [self ShowFacebookDialog];
    }
}

-(IBAction)postOnFacebook
{
    [self publishStream:nil];
}

-(IBAction)cancelPostOnFacebook
{
    [self HideFacebookDialog];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        [self HideFacebookDialog];
    }
    else
    {
        [self publishStream:nil];
    }
}
-(void)showMsgBox:(NSString *)text withTitle:(NSString *)title cancelButtonText:(NSString *)cText otherButtonText:(NSString *)cOther{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:title
                          message:text
                          delegate:self 
                          cancelButtonTitle:NSLocalizedString(cText,@"")
                          otherButtonTitles:NSLocalizedString(cOther,@""), nil ];
    [alert show];
    //[alert release];
}

@end
