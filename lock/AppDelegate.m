//
//  AppDelegate.m
//  lock
//
//  Created by 李金洋 on 2020/3/20.
//  Copyright © 2020 li. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <Bugly/Bugly.h>
#import "LogInViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = COLOR_WHITE;
    BaseNavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:[LogInViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [AMapServices sharedServices].apiKey = @"6a164f52cd5c8fc0966f50dac52cbeba";
    BuglyConfig * config = [[BuglyConfig alloc] init];
    config.reportLogLevel = BuglyLogLevelWarn;
    config.blockMonitorEnable = YES;
    config.unexpectedTerminatingDetectionEnable = YES;
    [Bugly startWithAppId:@"e562acc538" config:config];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]postNotificationName:NF_KEY_BACKGROUND object:nil];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]postNotificationName:NF_KEY_FOREGROUND object:nil];
}
- (void)applicationWillTerminate:(UIApplication *)application {

}
@end
