//
//  SynchronizedDemo.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "SynchronizedDemo.h"

/*
 @synchronized 实际是对mutex的封装。其次其底层初始化的时候是使用PTHREAD_MUTEX_RECURSIVE进行初始化的，所以其本质是一个递归锁的封装。
 由于其使用效率并不高，所以苹果并不推荐使用。
 @synchronized后面是放置一个锁对象。
 */

@implementation SynchronizedDemo

- (void)__saleTickets {
    
    static NSObject * lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [NSObject new];
    });
    
    @synchronized (lock) {
        [super __saleTickets];
    }
}

- (void)__drawMoney {
    @synchronized (self) {
        [super __drawMoney];
    }
}

- (void)__saveMoney {
    @synchronized (self) {
        [super __saveMoney];
    }
}


// 递归加锁
- (void)otherTest {
    @synchronized (self) {
        NSLog(@"123");
        [self otherTest];
    }
}


@end
