//
//  ViewController.m
//  CoreHelper
//
//  Created by chengbin on 15/10/10.
//  Copyright © 2015年 chengbin. All rights reserved.
//

#import "ViewController.h"
#import "CoreHelper.h"
#import "AppDelegate.h"
#import "CoreStatusSingleton.h"
@interface ViewController ()

@end

@implementation ViewController
NSString *_string;
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    _string = [CoreHelper currentCoreHelperNetworkStrStatus];
    NSLog(@"%@",_string);
    [CoreHelper sharedInstance].thisReachbility.unreachableBlock = ^(Reachability *reachability){
        NSLog(@"%@",reachability);
    };
    //NSLog(@"%@",[CoreHelper sharedInstance]);
    [CoreHelper sharedInstance].thisReachbility.reachabilityBlock = ^(Reachability *reachability,SCNetworkConnectionFlags flags){
        NSLog(@"%@,%d",reachability,flags);
    };
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    sharedAppDelegate.statusLabel.text = _string;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * statusString = [CoreHelper currentCoreHelperNetworkStrStatus];
         NSLog(@"%@",statusString);
        sharedAppDelegate.statusLabel.text = statusString;
    });
    
    
}
@end
