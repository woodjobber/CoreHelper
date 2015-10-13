//
//  AppDelegate.m
//  CoreHelper
//
//  Created by chengbin on 15/10/10.
//  Copyright © 2015年 chengbin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


@interface AppDelegate ()<CoreHelperProtocol>

@end
AppDelegate *sharedAppDelegate;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *vc = [ViewController new];
    self.window.rootViewController = vc;
    self.window.backgroundColor = [UIColor blackColor];
    sharedAppDelegate = self;
    [CoreHelper sharedInstance].thisReachbility.reachableQueue = ReachabilityQueueSerial;
    [CoreHelper sharedInstance].thisReachbility.reachableBlock = ^(Reachability *reach){
        NSLog(@"%@",reach);
        
    };
    
     [CoreHelper startDetectNetwork:self];
    
    CGFloat x = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat y = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    CGFloat width  = 200;
    CGFloat height = 300;
    CGRect rect = CGRectMake(x/2 - width/2, y/2 - height/2 - 200, width, height);
    self.statusLabel = [[UILabel alloc]initWithFrame:rect];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textAlignment   = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:64];
    self.statusLabel.textColor = [UIColor redColor];
    self.statusLabel.layer.shadowColor = [UIColor purpleColor].CGColor;
    self.statusLabel.layer.shadowOffset = CGSizeMake(4, 4);
    self.statusLabel.layer.shadowOpacity = 0.6f;
    [vc.view addSubview:self.statusLabel];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)coreHelperNetworkChangedNotification:(NSNotification *)noti{
   dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text =[[noti userInfo] objectForKey:CoreHelperCurrentNetworkStatusStrKey];
   });
   
}
@end
