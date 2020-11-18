//
//  ThreeViewController.m
//  RunLoopDemo
//
//  Created by 冯才凡 on 2020/11/18.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ThreeViewController.h"
#import "PermenantThread.h"
#import "PermenantCThread.h"

@interface ThreeViewController ()
@property (nonatomic, strong) PermenantCThread * thread;
@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"封装常驻线程";

    _thread = [PermenantCThread new];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    执行任务
    [_thread executeTaskBlock:^{
        NSLog(@"%s__%@",__func__, [NSThread currentThread]);
    }];
}

- (IBAction)stopAction {
    [self.thread stop];
}


- (void)dealloc
{
    NSLog(@"_%s_",__func__);
}

@end
