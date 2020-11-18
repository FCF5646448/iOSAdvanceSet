//
//  ViewController.m
//  RunLoopDemo
//
//  Created by 冯才凡 on 2020/11/17.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "SubViewController.h"
#import "ThreeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}



// 按钮模拟销毁子线程
- (IBAction)destroyThread:(id)sender {
    ThreeViewController * subvc = [ThreeViewController new];
    [self.navigationController pushViewController:subvc animated:YES];
}


@end
