//
//  FlipsideViewController.m
//  test
//
//  Created by Jury Giannelli on 05/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@implementation FlipsideViewController

@synthesize infoScroll;
@synthesize infoButton;
@synthesize infoControl;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageControlBeingUsed = NO;
    
    self.infoControl.currentPage = 0;
	self.infoControl.numberOfPages = 5;
	// Do any additional setup after loading the view, typically from a nib.
    [infoButton setImage:[UIImage imageNamed:@"infobutton_.png"] forState:UIControlEventTouchDown];
    
    infoScroll.contentSize = CGSizeMake(320*5, 0);
    
    [infoScroll setCanCancelContentTouches:NO];
    infoScroll.clipsToBounds = NO;		// default is NO, we want to restrict drawing within our inputScroll
    infoScroll.scrollEnabled = YES;
    infoScroll.pagingEnabled = YES;
    
    [self addImageWithName:@"instructions_0.png" atPosition:0];
    [self addImageWithName:@"instructions_1.png" atPosition:1];
    [self addImageWithName:@"instructions_2.png" atPosition:2];
    [self addImageWithName:@"instructions_3.png" atPosition:3];
    [self addImageWithName:@"instructions_4.png" atPosition:4];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = self.infoScroll.frame.size.width;
        int page = floor((self.infoScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.infoControl.currentPage = page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.infoScroll.frame.size.width * self.infoControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.infoScroll.frame.size;
    [self.infoScroll scrollRectToVisible:frame animated:YES];
    
    pageControlBeingUsed = YES;
}

- (IBAction)openAOA {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.artofapps.net"]];
}

- (void)addImageWithName:(NSString*)imageString atPosition:(int)position {
	// add image to scroll view
	UIImage *image = [UIImage imageNamed:imageString];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = CGRectMake(position*320, 0, 320, 251);
	[infoScroll addSubview:imageView];
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
