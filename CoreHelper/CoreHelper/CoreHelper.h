//
//  CoreHelper.h
//  CoreHelper
//
//  Created by chengbin on 15/10/10.
//  Copyright © 2015年 chengbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "CoreHelperNetworkStatus.h"
#import "CoreHelperSingleton.h"

FOUNDATION_EXPORT NSString * const CoreHelperNetworkChangedNotification;
FOUNDATION_EXPORT NSString * const CoreHelperCurrentNetworkStatusEnumKey;
FOUNDATION_EXPORT NSString * const CoreHelperCurrentNetworkStatusStrKey;

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol CoreHelperProtocol <NSObject>
@optional
- (void)coreHelperNetworkChangedNotification:(NSNotification *)noti;
@end

@interface CoreHelper : NSObject<NSCoding,NSCopying,NSMutableCopying>
@property (nonatomic, copy, readonly,getter=thisReachbility) Reachability *reachability;
/** Singleton*/
 AS_SINGLETON(CoreHelper)

/** 
 Start detecting network.
 
 @param detector The detector must comply with the protocol.
 */
+ (void)startDetectNetwork:(id<CoreHelperProtocol>)detector;

 /**
  Stop detecting network.
  
  @param detector The detector must comply with the protocol.
  */
+ (void)cancelDetectNetwork:(id<CoreHelperProtocol>)detector;

/**
  Get the current network status.
  @return  Returns status.
 */
+ (CoreHelperNetworkStatus)currentCoreHelperNetworkStatus;

/**
  Get the current network status string -- "None","Cellular","2G","3G","4G","WIFI","Unknown".
 */
+ (NSString *)currentCoreHelperNetworkStrStatus;

/**
 if the current network status is WIFI,return YES, NO otherwise.
 */
+ (BOOL)isWIFI;
/**
 if the current network connection status is 2G,return YES, NO otherwise.
 */
+ (BOOL)is2G;

/**
 if the current network connection status is 3G,return YES, NO otherwise.
 */
+ (BOOL)is3G;

/**
 if the current network connection status is 4G,return YES, NO otherwise.
 */
+ (BOOL)is4G;

/**
 if the current network connection status is vailable,return YES, NO otherwise.
 */
+ (BOOL)isNetworkaVailable;

/**
  Checks whether a local WiFi connection is available. if it is success,return YES, NO otherwise.
 */
+ (BOOL)checkLocalWIFI;
#if	TARGET_OS_IPHONE
- (BOOL)isReachableViaWiFi;
- (BOOL)isReachableViaWWAN;
- (BOOL)isReachable;
#endif
@end
