//
//  FlipsideViewController.h
//  test
//
//  Created by Jury Giannelli on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController {
    UIButton *infoButton;
    UIScrollView *infoScroll;
    UIPageControl *infoControl;
    BOOL pageControlBeingUsed;
}
@property (nonatomic, retain) IBOutlet UIScrollView *infoScroll;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UIPageControl *infoControl;

- (IBAction)changePage;
- (void)addImageWithName:(NSString*)imageString atPosition:(int)position;

@end
