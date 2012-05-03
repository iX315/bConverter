//
//  FlipsideViewController.h
//  test
//
//  Created by Jury Giannelli on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol SettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface SettingsViewController : UIViewController {
    IBOutlet UIButton *saveButton;
    IBOutlet UISwitch *autoCopySw;
    IBOutlet UILabel *settingsTitle;
    IBOutlet UILabel *autoCopyLb;
}
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic) IBOutlet UISwitch *autoCopySw;
-(IBAction)saveSettings;
@end
