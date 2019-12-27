//
//  SubController2.m
//  iOS 底层实现Demos
//
//  Created by 冯才凡 on 2019/11/21.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "SubController2.h"
#import "FCFNotificationCerter.h"

@interface SubController2 ()

@end

@implementation SubController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 50, 100, 44);
    [btn setTitle:@"click" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(postAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificate:) name:@"test" object:nil];
    
    [[FCFNotificationCerter defaultCenter] addObserver:self selector:@selector(notificate:) name:@"test" object:nil];
}


- (void)postAction:(UIButton *)btn {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil userInfo:nil];
    [[FCFNotificationCerter defaultCenter] postNotificationName:@"test" object:nil userInfo:nil];
}

- (void)notificate:(NSNotification *)noti {
    NSLog(@"receive notification2");
}

@end
