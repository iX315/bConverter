//
//  inputScrollController.h
//  bConverter
//
//  Created by Jury Giannelli on 31/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface inputScrollController : UIScrollView {
}

@property (nonatomic, retain) IBOutlet UIScrollView *inputScroll;
- (void)addImageWithName:(NSString*)imageString atUpPosition:(int)position;

@end
