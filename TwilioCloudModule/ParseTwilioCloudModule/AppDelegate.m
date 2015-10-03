//
//  AppDelegate.m
//  ParseTwilioCloudModule
//
//  Created by Mattieu Gamache-Asselin on 10/25/12.
//

#import "AppDelegate.h"
#import "FriendsTableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // ****************************************************************************
    // Add your Parse credentials here
    
    [Parse setApplicationId:@"0OxnK5A9fQBKrNLrdsTiq95ZnR7209NOQPQdocSv"
                  clientKey:@"MoKnfd95iVAnLHiyNBx25NIrPcKiIL63CTL57GL1"];
    //
    // ****************************************************************************
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    FriendsTableViewController *viewController = [[FriendsTableViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    return YES;
}

@end
