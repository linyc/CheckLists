//
//  AppDelegate.m
//  CheckLists
//
//  Created by CY on 9/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import "AppDelegate.h"
#import "AllListsViewController.h"
#import "DataModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    DataModel *_dataModel;
}

-(void)saveData
{
//    UINavigationController *navController = (UINavigationController*)self.window.rootViewController;
//    AllListsViewController *controller = navController.viewControllers[0];
//    [controller saveChecklists];
    [_dataModel saveChecklists];
}

//当应用启动的时候会立即调用didFinishLaunchingWithOptions方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _dataModel = [[DataModel alloc] init];
    UINavigationController *navController = (UINavigationController*)self.window.rootViewController;
    AllListsViewController *controller = navController.viewControllers[0];
    controller.dataModel = _dataModel;
    
    /* 本地通知
    //使⽤ dateWithTimeIntervalSinceNow这个便捷构造方法来创建了一个NSDate对象,它的准确时间是应用启动后10秒
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:10];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    //设置所在时区,这样系统会根据时区变化自动调整提醒时间
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = @"Ha ha ha,2015 year is coming soon";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertAction=@"pia pia pia";
    localNotification.hasAction=NO;
    localNotification.applicationIconBadgeNumber=2;
    
    //实际上任何一个iOS应用都提供了这样的一个对象,它可以处理和整个应用相关的功能。我们需要为UIApplication对象提供一个代理对象,以处理类似 applicationDidEnterBackground这样的消息。对于我们这个应用来说,UIApplication的代理对象就是ChecklistsAppDelegate。默认情况下,Xcode会为每个应⽤用提供一个app delegate。 虽然在开发的过程中通常不会过多接触到UIApplication,但在涉及到类似本地消息通知等特殊功能的时候,UIApplication对象还是很有用的
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
     */
    
    ///ios8 ，要注册本地通知
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    return YES;
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceivelocalNotification %@",notification);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [self saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self saveData];
}

@end
