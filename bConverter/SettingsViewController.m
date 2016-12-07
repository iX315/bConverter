//
//  FlipsideViewController.m
//  test
//
//  Created by Jury Giannelli on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

@synthesize saveButton;
@synthesize autoCopySw;
@synthesize accSw;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [settingsTitle setFont:[UIFont fontWithName:@"WW Digital" size:30.0]];
    [autoCopyLb setFont:[UIFont fontWithName:@"WW Digital" size:17.0]];
    [accLb setFont:[UIFont fontWithName:@"WW Digital" size:17.0]];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *autoCopy = [ud stringForKey:@"autoCopy"];
    NSString *accConv = [ud stringForKey:@"accConv"];
    [saveButton setImage:[UIImage imageNamed:@"save_button_p.png"] forState:UIControlEventTouchDown];
    
    if (autoCopy == @"1") {
        autoCopySw.on = YES;
    } else {
        autoCopySw.on = NO;
    }
    if (accConv == @"1") {
        accSw.on = YES;
    } else {
        accSw.on = NO;
    }
}

-(IBAction)saveSettings {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (autoCopySw.on == YES) {
        [ud setObject:@"1" forKey:@"autoCopy"];
    } else {
        [ud setObject:@"0" forKey:@"autoCopy"];
    }
    if (accSw.on == YES) {
        [ud setObject:@"1" forKey:@"accConv"];
    } else {
        [ud setObject:@"0" forKey:@"accConv"];
    }
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

@end
