//
//  CoreHelperNetworkStatus.h
//  CoreHelper
//
//  Created by chengbin on 15/10/10.
//  Copyright © 2015年 chengbin. All rights reserved.
//

#ifndef CoreHelper_NetworkStatus_h
#define CoreHelper_NetworkStatus_h

typedef enum:NSInteger {
    
    CoreHelperNetworkStatusNone = 0,    /**< Not Reachability*/
    
    CoreHelperNetworkStatusWIFI = 1,    /**< WIFI*/
    
    CoreHelperNetworkStatusWWAN = 2,    /**< Cellular*/
    
    CoreHelperNetworkStatus2G   = 3,    /**< 2G network*/
    
    CoreHelperNetworkStatus3G   = 4,    /**< 3G network*/
    
    CoreHelperNetworkStatus4G   = 5,    /**< 4G network*/
    
    CoreHelperNetworkStatusUnknown       /**< Unknown Network*/
  
}CoreHelperNetworkStatus;/**<Network Status*/

#endif /* CoreHelper_NetworkStatus_h */
