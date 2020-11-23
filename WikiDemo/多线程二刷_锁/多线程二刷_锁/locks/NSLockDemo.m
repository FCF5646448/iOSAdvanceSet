//
//  NSLockDemo.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "NSLockDemo.h"

/*
 NSLock 是对pthread_mutex的普通锁的封装：
 类似：
 pthread_mutexattr_t attr;
 pthread_mutexattr_init(&attr);
 pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT)
 pthread_mutex(&_mutex, &attr); //或者第二个参数，直接传入null
 
 NSRecursiveLock 是对pthread_mutex的递归锁的封装：
 类似：
 pthread_mutexattr_t attr;
 pthread_mutexattr_init(&attr);
 pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 pthread_mutex(&_mutex, &attr);
 
 */

@interface NSLockDemo()
@property (nonatomic, strong) NSLock * moneyLock;
@property (nonatomic, strong) NSLock * ticketLock;

@property (nonatomic, strong) NSRecursiveLock * testLock;

@end

@implementation NSLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _moneyLock = [[NSLock alloc] init];
        _ticketLock = [[NSLock alloc] init];
        _testLock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (void)__drawMoney {
    [_moneyLock lock];
    [super __drawMoney];
    [_moneyLock unlock];
}

- (void)__saveMoney {
    [_moneyLock lock];
    [super __saveMoney];
    [_moneyLock unlock];
}

- (void)__saleTickets {
    [_ticketLock lock];
    [super __saleTickets];
    [_ticketLock unlock];
}

- (void)otherTest {
    static int count = 10;
    [_testLock lock];
    NSLog(@"test_%d", count);
    count --;
    if (count > 0) {
        [self otherTest];
    }
    [_testLock unlock];
    
}

@end
