//
//  MutexDemo2.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "MutexDemo2.h"
#import <pthread.h>

@interface MutexDemo2()

@property (nonatomic, assign) pthread_mutex_t mutex;

@end

@implementation MutexDemo2

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&_mutex, &attr);
        pthread_mutexattr_destroy(&attr);
    }
    return self;
}

#pragma MARK -

/*
 下面两个函数，otherTest中，先加锁了，然后在锁内调用了otherTest2函数，otherTest2函数又对相同的锁进行了加锁。
 这样的话，要执行otherTest2函数，得要先等待_mutex解锁，而_mutex想要解锁，就得先执行完otherTest函数，所以就导致了相互等待的一个结果。
 
 解决方法：
    两个函数使用两把不同的锁。
 
 但是如果函数是递归呢？就没法使用不同的锁的解决方案了。
 所以就只能使用**递归锁**
    {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&_mutex, &attr);
        pthread_mutexattr_destroy(&attr);
    }
 
 疑问：正常的情况下，想要使用lock包含的代码，则必须先等待锁先被解锁unlock，否则mutex就是进入休眠等待的状态。而这里进行递归调用，根据函数调用栈的来看，递归的调用是从函数栈底层一层一层往上开辟栈空间，而执行是最上层开始一层一层往下执行。这样的话，上层的函数等待下层函数解锁，下层函数等待上层函数执行完成。为什么这不会造成等待解锁的问题呢？
 
 原因：递归锁允许同一个线程对同一把锁进行重复加锁。
 线程1：otherTest（+loack-）
        otherTest（+loack-）
         otherTest（+loack-）
 其次，如果有另外一个线程调用otherTest函数，则就先会等待解锁。所以也能够保证线程安全。
 
 */

- (void)otherTest {
    pthread_mutex_lock(&_mutex);
    NSLog(@"%s", __func__);
    [self otherTest2];
    static int count = 0;
    if (count < 10) {
        count += 1;
        [self otherTest];
    }
    pthread_mutex_unlock(&_mutex);
}

- (void)otherTest2 {
    pthread_mutex_lock(&_mutex);
    NSLog(@"%s", __func__);
    pthread_mutex_unlock(&_mutex);
}




-(void)dealloc {
    pthread_mutex_destroy(&_mutex);
}

@end
