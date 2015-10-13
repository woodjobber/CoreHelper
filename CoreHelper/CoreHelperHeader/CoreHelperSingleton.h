//
//  CoreHelperSingleton.h
//  CoreHelper
//
//  Created by chengbin on 15/10/10.
//  Copyright © 2015年 chengbin. All rights reserved.
//

#ifndef AS_SINGLETON
#define AS_SINGLETON( __class)\
- (__class *)sharedInstance;\
+ (__class *)sharedInstance;

#endif

#if __has_feature(objc_arc)
#ifndef DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
- (__class *)sharedInstance \
{\
return [__class sharedInstance]; \
} \
static __class * __singleton__ = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
__singleton__ = [super allocWithZone:zone];\
}); \
return __singleton__; \
}   \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
dispatch_once( &once, ^{ if(__singleton__ == nil){ __singleton__ = [[__class alloc] init]; } } ); \
return __singleton__; \
} \
  \
 - (id)copyWithZone:(NSZone *)zone \
{  \
    return __singleton__; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone \
{ \
   return __singleton__; \
}

#endif

#else

#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.


#endif