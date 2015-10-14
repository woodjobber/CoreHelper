//
//  AppDelegate.h
//  CoreHelper
//
//  Created by chengbin on 15/10/10.
//  Copyright © 2015年 chengbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UILabel *statusLabel;

@end
extern AppDelegate *sharedAppDelegate;
