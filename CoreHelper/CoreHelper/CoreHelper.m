//
//  CoreHelper.m
//  CoreHelper
//
//  Created by chengbin on 15/10/10.
//  Copyright © 2015年 chengbin. All rights reserved.
//

#import "CoreHelper.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <objc/runtime.h>
#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.
#endif

static inline NSArray *tech2GArray(){
    static  NSArray *_tech2GArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tech2GArray = [[NSArray alloc]initWithObjects:CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyGPRS,nil];
    });
    return _tech2GArray;
}
static inline NSArray *tech3GArray(){
    static NSArray *_tech3GArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tech3GArray = [NSArray arrayWithObjects:CTRadioAccessTechnologyHSDPA,
                        CTRadioAccessTechnologyWCDMA,
                        CTRadioAccessTechnologyHSUPA,
                        CTRadioAccessTechnologyCDMA1x,
                        CTRadioAccessTechnologyCDMAEVDORev0,
                        CTRadioAccessTechnologyCDMAEVDORevA,
                        CTRadioAccessTechnologyCDMAEVDORevB,
                        CTRadioAccessTechnologyeHRPD, nil];
    });
    return _tech3GArray;
}
static inline NSArray *tech4GArray(){
    static NSArray *_tech4GArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tech4GArray = @[CTRadioAccessTechnologyLTE];
    });
    return _tech4GArray;
}

@interface CoreHelper()

@property (nonatomic, strong)CoreHelper *sharedCoreHelper;

@property (nonatomic, strong)CTTelephonyNetworkInfo *telephonyNetworkInfo;

@property (nonatomic, strong)NSString *currentRailAccessTelephony;

@property (nonatomic, copy) Reachability *reachability;

@property (nonatomic, assign)BOOL isNotification;

@property (nonatomic, strong)NSArray *tech2GArray;

@property (nonatomic, strong)NSArray *tech3GArray;

@property (nonatomic, strong)NSArray *tech4GArray;

@property (nonatomic, strong)NSArray *coreHelperNetworkStatusStrArray;

@property (nonatomic, assign)id<CoreHelperProtocol>delegate;

@property (nonatomic, strong)NSString *status_ap;
@end

NSString * const CoreHelperNetworkChangedNotification  = @"CoreHelperNetworkChangedNotification";
NSString * const CoreHelperCurrentNetworkStatusEnumKey = @"CurrentNetworkStatusEnumKey";
NSString * const CoreHelperCurrentNetworkStatusStrKey  = @"CurrentNetworkStatusStrKey";

@implementation CoreHelper
-(void)dealloc{
    [self deallocObserver];
    self.status_ap = nil;
    self.reachability                    = nil;
    self.tech2GArray                     = nil;
    self.tech3GArray                     = nil;
    self.tech4GArray                     = nil;
    self.coreHelperNetworkStatusStrArray = nil;
    self.telephonyNetworkInfo            = nil;
    self.sharedCoreHelper                = nil;
}
-(void)deallocObserver{
    [CoreHelper cancelAllObservers:self.delegate,self, nil];
}
-(Reachability *)thisReachbility{
    return [self reachability];
}
DEF_SINGLETON(CoreHelper);
+(void)initialize{
    CoreHelper *helper          = [CoreHelper sharedInstance];
    helper.telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc]init];
    helper.status_ap            = nil;
}

#pragma mark -- Lazy Methods
-(CoreHelper *)sharedCoreHelper{
    if (!_sharedCoreHelper) {
        _sharedCoreHelper = [self sharedCoreHelper];
    }
    return _sharedCoreHelper;
}
-(Reachability *)reachability{
    if (!_reachability) {
        _reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
         if (!_reachability) {
             _reachability = [Reachability reachabilityForInternetConnection];
        }
    
    }
    return _reachability;
}

-(NSString *)currentRailAccessTelephony{
    if (!_currentRailAccessTelephony) {
        _currentRailAccessTelephony = self.telephonyNetworkInfo.currentRadioAccessTechnology;
    }
    return _currentRailAccessTelephony;
}
-(CTTelephonyNetworkInfo *)telephonyNetworkInfo{
    if (!_telephonyNetworkInfo) {
        _telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc]init];
    }
    return _telephonyNetworkInfo;
}

-(NSArray *)coreHelperNetworkStatusStrArray{
    if (!_coreHelperNetworkStatusStrArray) {
        _coreHelperNetworkStatusStrArray = @[@"None",@"WIFI",@"Cellular",@"2G",@"3G",@"4G",@"Unknown"];
    }
    return _coreHelperNetworkStatusStrArray;
}
#pragma mark -- Public Methods
+(CoreHelperNetworkStatus)currentCoreHelperNetworkStatus{
   
    return [[CoreHelper sharedInstance] networkSatusAndRadioAccessTechnology];
}
+(NSString *)currentCoreHelperNetworkStrStatus{
    return [[CoreHelper sharedInstance].coreHelperNetworkStatusStrArray[[self currentCoreHelperNetworkStatus]] copy];
}

+(void)startDetectNetwork:(id<CoreHelperProtocol>)detector{
    
    CoreHelper *helper = [CoreHelper sharedInstance];
    if (helper.isNotification) {
        [self cancelDetectNetwork:detector];
    }
    helper.delegate = detector;
    [CoreHelper registerAllObservers:detector,helper, nil];
    [helper.reachability startNotifier];
    helper.isNotification = YES;
}
+(void)cancelDetectNetwork:(id<CoreHelperProtocol>)detector{
    CoreHelper *helper = [CoreHelper sharedInstance];
    if (!helper.isNotification) {
        return;
    }
    helper.delegate = nil;
    [self cancelAllObservers:helper,detector, nil];
    [helper.reachability stopNotifier];
    helper.isNotification = NO;
}

#pragma mark- Private Methods

-(CoreHelperNetworkStatus)networkSatusAndRadioAccessTechnology{
    CoreHelperNetworkStatus networkStatus = (CoreHelperNetworkStatus)[self.reachability currentReachabilityStatus];
    
    NSString *tech = self.currentRailAccessTelephony;
    
    if (networkStatus == CoreHelperNetworkStatusWWAN && tech) {
        if ([tech2GArray() containsObject:tech]) {
            networkStatus = CoreHelperNetworkStatus2G;
        }else if ([tech3GArray() containsObject:tech]){
            networkStatus = CoreHelperNetworkStatus3G;
        }else if ([tech4GArray() containsObject:tech]){
            networkStatus = CoreHelperNetworkStatus4G;
        }
    }
    return networkStatus;
}

+ (void)cancelAllObservers:(id)firstObj,...NS_REQUIRES_NIL_TERMINATION{
    va_list ap;
    id arg;
    if(firstObj != nil){
        va_start(ap, firstObj);
        if([firstObj isKindOfClass:[self class]]){
            [[NSNotificationCenter defaultCenter] removeObserver:(CoreHelper *)firstObj name:kReachabilityChangedNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:(CoreHelper *)firstObj name:CTRadioAccessTechnologyDidChangeNotification object:nil];
        }
        while ((arg = va_arg(ap, id))!= nil){
            
            if([arg isKindOfClass:[self class]]){
                
            if([firstObj conformsToProtocol:@protocol(CoreHelperProtocol)]){
                
                [[NSNotificationCenter defaultCenter]removeObserver:firstObj name:CoreHelperNetworkChangedNotification object:(CoreHelper *)arg];
                }
                [[NSNotificationCenter defaultCenter] removeObserver:(CoreHelper *)arg name:kReachabilityChangedNotification object:nil];
                [[NSNotificationCenter defaultCenter] removeObserver:(CoreHelper *)arg name:CTRadioAccessTechnologyDidChangeNotification object:nil];
                
            }else if ([arg conformsToProtocol:@protocol(CoreHelperProtocol)]){
                if([firstObj isKindOfClass:[self class]]){
                  [[NSNotificationCenter defaultCenter]removeObserver:arg name:CoreHelperNetworkChangedNotification object:(CoreHelper *)firstObj];
                 
                }
            }
        }
        va_end(ap);
    }
}
+(void)registerAllObservers:(id)firstObj,...NS_REQUIRES_NIL_TERMINATION{
    va_list ap;
    id arg;
    if(firstObj != nil){
        va_start(ap, firstObj);
        if([firstObj isKindOfClass:[self class]]){
            [[NSNotificationCenter defaultCenter] addObserver:firstObj selector:@selector(coreHelperNetWorkStatusChanged:) name:kReachabilityChangedNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:firstObj selector:@selector(coreHelperNetWorkStatusChanged:) name:CTRadioAccessTechnologyDidChangeNotification object:nil];
        }
        while ((arg = va_arg(ap, id)) != nil){
            if([arg isKindOfClass:[self class]]){
                if([firstObj conformsToProtocol:@protocol(CoreHelperProtocol)]){
                    [[NSNotificationCenter defaultCenter]addObserver:firstObj selector:@selector(coreHelperNetworkChangedNotification:) name:CoreHelperNetworkChangedNotification object:(CoreHelper *)arg];
                }
                [[NSNotificationCenter defaultCenter] addObserver:(CoreHelper *)arg selector:@selector(coreHelperNetWorkStatusChanged:) name:kReachabilityChangedNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:(CoreHelper *)arg selector:@selector(coreHelperNetWorkStatusChanged:) name:CTRadioAccessTechnologyDidChangeNotification object:nil];
                
            }else if([arg conformsToProtocol:@protocol(CoreHelperProtocol)]){
                if([firstObj isKindOfClass:[self class]]){
                  [[NSNotificationCenter defaultCenter]addObserver:arg selector:@selector(coreHelperNetworkChangedNotification:) name:CoreHelperNetworkChangedNotification object:(CoreHelper *)firstObj];
                }
            }
        }
        va_end(ap);
    }
   
}

#pragma mark -- Public Methods
+(BOOL)isNetworkaVailable{
    return [CoreHelper currentCoreHelperNetworkStatus]!= CoreHelperNetworkStatusNone || [CoreHelper currentCoreHelperNetworkStatus]!= CoreHelperNetworkStatusUnknown;
}
+(BOOL)isWIFI{
    return [CoreHelper currentCoreHelperNetworkStatus] == CoreHelperNetworkStatusWIFI;
}
+(BOOL)is2G{
    return [CoreHelper currentCoreHelperNetworkStatus] == CoreHelperNetworkStatus2G;
}
+(BOOL)is3G{
    return [CoreHelper currentCoreHelperNetworkStatus] == CoreHelperNetworkStatus3G;
}
+(BOOL)is4G{
    return [CoreHelper currentCoreHelperNetworkStatus] == CoreHelperNetworkStatus4G;
}
+(BOOL)checkLocalWIFI{
    Reachability*rcb = [Reachability reachabilityForLocalWiFi];
    CoreHelperNetworkStatus NetworkStatus = (CoreHelperNetworkStatus)[rcb currentReachabilityStatus];
    return NetworkStatus == CoreHelperNetworkStatusWIFI;
}

-(BOOL)isReachable{
    return [self.reachability isReachable];
}
-(BOOL)isReachableViaWiFi{
    return [self.reachability isReachableViaWiFi];
}
-(BOOL)isReachableViaWWAN{
    return [self.reachability isReachableViaWWAN];
}

#pragma mark -- Delegate
-(void)coreHelperNetWorkStatusChanged:(NSNotification *)noti{
    if (noti.name == CTRadioAccessTechnologyDidChangeNotification && noti.object) {
        self.currentRailAccessTelephony = self.telephonyNetworkInfo.currentRadioAccessTechnology;
    }
    [self postCoreHelperNetworkChangeNotification];
}
-(void)postCoreHelperNetworkChangeNotification{
    NSString *str     = [CoreHelper currentCoreHelperNetworkStrStatus];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@([CoreHelper currentCoreHelperNetworkStatus]),CoreHelperCurrentNetworkStatusEnumKey,str,CoreHelperCurrentNetworkStatusStrKey, nil];
    if (self.status_ap.hash != str.hash) {
        self.status_ap = str;
        //this makes sure the change notification happens on the Main thread.
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [[NSNotificationCenter defaultCenter] postNotificationName:CoreHelperNetworkChangedNotification object:self userInfo:dic];
        });
       
    }
}



#pragma mark -- NSCopying Protocol
- (void)encodeWithCoder:(NSCoder *)encoder{
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; ++i) {
        Ivar var         = ivars[i];
        const char *name = ivar_getName(var);
        NSString *key    = [NSString stringWithUTF8String:name];
        id value         = [self valueForKey:key];
        [encoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; ++i) {
            Ivar ivar        = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key    = [NSString stringWithUTF8String:name];
            id value         = [decoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

@end
