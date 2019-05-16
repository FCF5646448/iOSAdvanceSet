//
//  ViewController.m
//  NSTimer破除循环引用
//
//  Created by 冯才凡 on 2019/5/16.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "Share.h"


@interface ViewController ()

@end

@implementation ViewController

int global_var = 4;
static int static_global_var = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    [Share shareInstance].str = @"123";
    
    int var = 6;
    __unsafe_unretained id unsafe_obj = nil;
    __strong id strong_obj = nil;
    static int static_var = 3;
    
    void (^Block)(void) = ^{
        NSLog(@"局部变量<基本数据类型> var %d",var);
        NSLog(@"局部变量<__unsafe_unretained var %@",unsafe_obj);
        NSLog(@"局部变量<__strong var %@",strong_obj);
        NSLog(@"静态变量： %d", static_var);
        NSLog(@"全局变量：%d",global_var);
        NSLog(@"静态全局变量：%d",static_global_var);
    };
    Block();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    NSLog(@"%@", [Share shareInstance].str);
}


@end
