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
@interface ViewController ()

@end

@implementation ViewController
NSString *_string;
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view, typically from a nib.
    _string = [CoreHelper currentCoreHelperNetworkStrStatus];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    sharedAppDelegate.statusLabel.text = _string;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSString * statusString = [CoreHelper currentCoreHelperNetworkStrStatus];
    sharedAppDelegate.statusLabel.text = statusString;
}
@end
