# CoreHelper
#一、功能
1.可以检测2G,3G,4G,WIFI网络状态.

2.针对 Reachability 进行封装

3.在Reachability中，增加一些新的API.

#二、如何使用

步骤：1.引用libCoreHelper.framework 库到工程，并且导入头文件"CoreHelper.h"
      
      2.遵守协议 CoreHelperProtocol，实现- (void)coreHelperNetworkChangedNotification:(NSNotification *)noti方法;这是一个可选的，还可以用block回调监听网络状态改变，像这样使用
      
      [CoreHelper sharedInstance].thisReachbility.reachableBlock = ^(Reachability *reach){
        NSLog(@"%@",reach);
        
    };
    
    [CoreHelper sharedInstance].thisReachbility.unreachableBlock = ^(Reachability *reachability){
        NSLog(@"%@",reachability);
    };
    
    [CoreHelper sharedInstance].thisReachbility.reachabilityBlock = ^(Reachability *reachability,SCNetworkConnectionFlags         flags){
        NSLog(@"%@,%d",reachability,flags);
    };
      
      3.开始监听网络状态 [CoreHelper startDetectNetwork:self];
      
      4.获取当前网络状态 [CoreHelper currentCoreHelperNetworkStrStatus];
#三、总结

   如果存在逻辑错误，或者其它bug，欢迎给我发邮件 woodjobber@outlook.com;
   
   Blog [http://woodjobber.github.io/](http://woodjobber.github.io/)
