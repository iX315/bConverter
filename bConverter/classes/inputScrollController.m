//
//  inputScrollController.m
//  bConverter
//
//  Created by Jury Giannelli on 31/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "inputScrollController.h"

@implementation inputScrollController

@synthesize inputScroll;

-(void)awakeFromNib {
    //self = [super init];
    [inputScroll setCanCancelContentTouches:NO];
    inputScroll.clipsToBounds = NO;		// default is NO, we want to restrict drawing within our inputScroll
    inputScroll.scrollEnabled = YES;
    inputScroll.pagingEnabled = NO;
    
    [self addImageWithName:@"button_up_hex.png" atUpPosition:-2];
    [self addImageWithName:@"button_up_ott.png" atUpPosition:-1];
    [self addImageWithName:@"button_up_dec.png" atUpPosition:0];
    [self addImageWithName:@"button_up_bin.png" atUpPosition:1];
    [self addImageWithName:@"button_up_hex.png" atUpPosition:2];
    [self addImageWithName:@"button_up_ott.png" atUpPosition:3];
    [self addImageWithName:@"button_up_dec.png" atUpPosition:4];
    [self addImageWithName:@"button_up_bin.png" atUpPosition:5];
    [self addImageWithName:@"button_up_hex.png" atUpPosition:6];
    [self addImageWithName:@"button_up_ott.png" atUpPosition:7];
    [self addImageWithName:@"button_up_dec.png" atUpPosition:8];
    [self addImageWithName:@"button_up_bin.png" atUpPosition:9];
    [self addImageWithName:@"button_up_hex.png" atUpPosition:10];
    
    inputScroll.contentSize = CGSizeMake(640, 0);    
    [inputScroll setContentOffset:CGPointMake(40,0) animated:YES];
    //return self;
}

- (void)addImageWithName:(NSString*)imageString atUpPosition:(int)position {
	// add image to scroll view
	UIImage *image = [UIImage imageNamed:imageString];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = CGRectMake(position*80, 0, 80, 86);
	[inputScroll addSubview:imageView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)inputScroll withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //1st HEX
    if (targetContentOffset->x >= 0 && targetContentOffset->x <= 79) {
        velocity = CGPointMake(100, 0);
        *targetContentOffset = CGPointMake(40, 0);
        //inputSet = @"HEX";
    }
    //2nd OTT
    if (targetContentOffset->x >= 80 && targetContentOffset->x <= 159) {
        velocity = CGPointMake(100, 0);
        *targetContentOffset = CGPointMake(120, 0);
        //inputSet = @"OTT";
    }
    //3th DEC
    if (targetContentOffset->x >= 160 && targetContentOffset->x <= 239) {
        velocity = CGPointMake(100, 0);
        *targetContentOffset = CGPointMake(200, 0);
        //inputSet = @"DEC";
    }
    //4th BIN
    if (targetContentOffset->x >= 240 && targetContentOffset->x <= 320) {
        velocity = CGPointMake(100, 0);
        *targetContentOffset = CGPointMake(280, 0);
        //inputSet = @"BIN";
    }
}

@end