//
//  ViewController.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "BaseDemo.h"
#import "OSSpinlinkDemo.h"
#import "OSUnfairLockDemo.h"
#import "MutexDemo.h"
#import "MutexDemo2.h"
#import "MutexDemo3.h"
#import "NSLockDemo.h"
#import "NSConditionDemo.h"
#import "NSConditionLockDemo.h"
#import "SerialAQueueDemo.h"
#import "SemaphoreDemo.h"
#import "SynchronizedDemo.h"
#import "FileRWDemo.h"
#import "FIleRWDemo2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BaseDemo * demo = [[FIleRWDemo2 alloc] init];
//    [demo ATM];
//    [demo tickets];
    [demo otherTest];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}




@end
