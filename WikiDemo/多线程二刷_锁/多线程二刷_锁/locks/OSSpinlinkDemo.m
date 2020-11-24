//
//  OSSpinlinkDemo.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "OSSpinlinkDemo.h"
#import <libkern/OSAtomic.h>

/*
 OSSpinLock是自旋锁，
 自旋锁是忙等的锁，被访问资源被锁时，线程不会休眠，而是不停地循环等待，直到被锁资源被释放，所以自旋锁效率较高。但是存在优先级反转的问题：优先级低的线程先获取资源（临界区），优先级高的线程未获取到资源，但是优先级高的线程将被优先调度。 最终导致优先级更高的线程一直在等待解锁，但是却会一直占用CPU，优先级低的线程获取到资源却没有CPU去执行，而无法释放锁；最终导致相互等待的结果。所以自旋锁已经不再使用了。
 
 从汇编底层可以追踪到，自旋锁等待期间实际就是一直在使用一个while循环去试探锁有没有被释放掉。
 
 API：
 // 初始化
 OSSpinLock lock = OS_SPINLOCK_INIT;
 // 尝试加锁
 OSSpinLockTry(&_lock);
 //加锁
 OSSpinLockLock(&_lock);
 //解锁
 OSSpinLockUnlock(&_lock);
 
 */

@interface OSSpinlinkDemo()
@property (nonatomic, assign) OSSpinLock moneyLock;
@property (nonatomic, assign) OSSpinLock ticketLock;
@end

@implementation OSSpinlinkDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moneyLock = OS_SPINLOCK_INIT;
        self.ticketLock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)__drawMoney {
    OSSpinLockLock(&_moneyLock);
    [super __drawMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__saveMoney {
    OSSpinLockLock(&_moneyLock);
    [super __saveMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__saleTickets {
    OSSpinLockLock(&_ticketLock);
    [super __saleTickets];
    OSSpinLockUnlock(&_ticketLock);
}

@end
