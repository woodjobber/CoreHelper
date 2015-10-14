# CoreHelper
一、功能
1.可以检测2G,3G,4G,WIFI网络状态.

2.针对 Reachability 进行封装

3.在Reachability中，增加一些新的API.

二、如何使用

步骤：1.引用libCoreHelper.framework 库到工程，并且导入头文件"CoreHelper.h"
      
      2.遵守协议 CoreHelperProtocol，实现- (void)coreHelperNetworkChangedNotification:(NSNotification *)noti方法;
      
      3.开始监听网络状态 [CoreHelper startDetectNetwork:self];
      
      4.获取当前网络状态 [CoreHelper currentCoreHelperNetworkStrStatus];
