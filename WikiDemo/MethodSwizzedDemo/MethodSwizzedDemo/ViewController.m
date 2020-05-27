//
//  ViewController.m
//  MethodSwizzedDemo
//
//  Created by 冯才凡 on 2020/5/28.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
}


- (void)test {
    printf("ViewController test");
}

@end
