//
//  ViewController.m
//  封装GCD定时器
//
//  Created by 冯才凡 on 2020/11/25.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "FCFTimer.h"

@interface ViewController ()
@property (nonatomic, copy) NSString * task;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"begin");
    _task = [FCFTimer execTask:^{
        NSLog(@"1111");
    } start:3.0 interval:1.0 repeats:YES async:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [FCFTimer cancelTask:_task];
}


@end
