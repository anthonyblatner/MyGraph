//
//  MGAppDelegate.m
//  MyGraph
//
//  Created by Anthony Blatner on 10/23/12.
//  Copyright (c) 2012 AMB Software. All rights reserved.
//

#import "MGAppDelegate.h"

#import "MGViewController.h"

@implementation MGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[MGViewController alloc] initWithNibName:@"MGViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[MGViewController alloc] initWithNibName:@"MGViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //
    DLog(@"start");
    
    CGPoint point1 = CGPointMake(1.0, 1.5);
    CGPoint point2 = CGPointMake(2.0, 2.5);
    CGPoint point3 = CGPointMake(3.0, 3.5);
    CGPoint point4 = CGPointMake(4.0, 4.5);
    CGPoint point5 = CGPointMake(5.0, 5.5);
    
    CGPoint points[] = {point1, point2, point3, point4, point5};
    
//    DLog(@"points: %@", points);
    DLog(@"sizeof(points): %lu", sizeof(points));
    DLog(@"sizeof(CGPoint): %lu", sizeof(CGPoint));
    DLog(@"number of points: %lu", sizeof(points) / sizeof(CGPoint));
    //
    
    self.points = points;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    DLog(@"sizeof(self.points): %lu", sizeof(self.points));
    DLog(@"sizeof(*self.points): %lu", sizeof(*self.points));
    DLog(@"self.points[1].x: %f", (self.points)[1].x);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
