//
//  OSUnfairLockDemo.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "OSUnfairLockDemo.h"
#import <os/lock.h>

/*
 os_unfair_lock是从iOS10开始用于取代不安全的OSSpinLock的锁。
 os_unfair_lock不是忙等的锁，它在等待过程中，线程会进入休眠。
 
  从汇编底层可以追踪到，os_unfair_lock也是在等待期间调用了系统函数进入了休眠状态。所以它也是一把互斥锁。
 
 API：
 //初始化
 os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
 // 尝试加锁
 os_unfair_lock_trylock(&_lock);
 // 加锁
 os_unfair_lock_lock(&_lock);
 // 解锁
 os_unfair_lock_unlock(&_lock);
 
 
 
 */


@interface OSUnfairLockDemo()
@property (nonatomic, assign) os_unfair_lock moneyLock;
@property (nonatomic, assign) os_unfair_lock ticketLock;

@end

@implementation OSUnfairLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moneyLock = OS_UNFAIR_LOCK_INIT;
        self.ticketLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)__saleTickets {
    os_unfair_lock_lock(&_ticketLock);
    [super __saleTickets];
    os_unfair_lock_unlock(&_ticketLock);
}

- (void)__saveMoney {
    os_unfair_lock_lock(&_moneyLock);
    [super __saveMoney];
    os_unfair_lock_unlock(&_moneyLock);
}

- (void)__drawMoney {
    os_unfair_lock_lock(&_moneyLock);
    [super __drawMoney];
    os_unfair_lock_unlock(&_moneyLock);
}
@end
