//
//  AppDelegate.m
//  Tinder
//
//  Created by Ivan Ruiz Monjo on 25/08/14.
//  Copyright (c) 2014 ivan. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    [Parse setApplicationId:@"QOEDDR90baHtuQNFHxblVbDPY9BRKuNxXLcIegnQ"
                  clientKey:@"QlwXT1FOPfunC0oj1zMRO1oiYZH1DnulG2KmWm0s"];
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];

    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    currentInstallation.channels = @[@"global"];
    if ([PFUser currentUser]) {
        currentInstallation.channels = @[@"global",[@"user_" stringByAppendingString:[PFUser currentUser].objectId]];
    }
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:receivedMessage object:userInfo];
    //[PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
