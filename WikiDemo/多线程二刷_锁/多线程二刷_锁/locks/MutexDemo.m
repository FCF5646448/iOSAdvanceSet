//
//  MutexDemo.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "MutexDemo.h"
#import <pthread.h>

/*
 pthread_mutex: 互斥锁，等待的过程中会进入休眠；
 
 从汇编底层可以追踪到，互斥锁等待期间调用了系统的syscall函数去进入了休眠状态。
 
 API：
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    // PTHREAD_MUTEX_DEFAULT 普通类型
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    // 初始化锁, 第二个参数可以传null，传null就表示是PTHREAD_MUTEX_DEFAULT
    pthread_mutex_init(&_lock, &attr);
    // 销毁属性
    pthread_mutexattr_destroy(&attr);

  //加锁
  pthread_mutex_lock(&_lock);
  //关锁
  pthread_mutex_unlock(&_lock);
 
  // 销毁
  pthread_mutex_destroy(&_lock);
 
 
  加解锁的原则就是：加锁之前必须等待别人先解锁。
 
 */

@interface MutexDemo()
@property (nonatomic, assign) pthread_mutex_t moneyLock;
@property (nonatomic, assign) pthread_mutex_t ticketLock;
@end

@implementation MutexDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self __initMutex:&(_moneyLock)];
        [self __initMutex:&(_ticketLock)];
    }
    return self;
}


- (void)__initMutex:(pthread_mutex_t *) mutex {
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    // PTHREAD_MUTEX_DEFAULT 普通类型
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    // 初始化锁, 第二个参数可以传null，传null就表示是PTHREAD_MUTEX_DEFAULT
    pthread_mutex_init(mutex, &attr);
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
}

- (void)__saleTickets {
    pthread_mutex_lock(&_ticketLock);
    [super __saleTickets];
    pthread_mutex_unlock(&_ticketLock);
}

- (void)__saveMoney {
    pthread_mutex_lock(&_moneyLock);
    [super __saveMoney];
    pthread_mutex_unlock(&_moneyLock);
}

- (void)__drawMoney {
    pthread_mutex_lock(&_moneyLock);
    [super __drawMoney];
    pthread_mutex_unlock(&_moneyLock);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_moneyLock);
    pthread_mutex_destroy(&_ticketLock);
}

@end
