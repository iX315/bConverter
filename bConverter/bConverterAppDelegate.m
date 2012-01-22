//
//  bConverterAppDelegate.m
//  bConverter
//
//  Created by Jury Giannelli on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "bConverterAppDelegate.h"
#import "Utilities.h"

@implementation bConverterAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
    // Override point for customization after application launch.
    [TestFlight takeOff:@"aa3dd3073a41e20a6a3740f978479673_NDM4NjEyMDExLTEyLTA2IDA1OjE0OjE0LjE5MTM0Nw"];
    
    //check md5 - read md5 sum of app on the info plist but md5 must not be normal but cripted with self-made cript if not exist or modifyed bye bye app
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* ctrl = [infoDict objectForKey:@"ctrl"];
        //NSLog(@"ctrl value: %@", ctrl);
    
    [Utilities getExecutableFileMD5Signature];
    
    if ([ctrl isEqualToString:@"strunz"]) {
        [self.window makeKeyAndVisible];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Cracked" message:@"This application was cracked..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil , nil];
        [alert show];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
