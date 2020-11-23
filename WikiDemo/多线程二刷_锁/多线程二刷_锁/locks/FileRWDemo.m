//
//  FileRWDemo.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/23.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "FileRWDemo.h"
#import <pthread.h>

/*
 读写锁： pthread_rwlock_t
 等待锁的线程会进入休眠
 
 API ：
 // 初始化锁
 pthread_rwlock_init(&_lock, NULL);
 // 读-加锁
 pthread_rwlock_rdlock(&_lock);
 // 读-尝试加锁
 pthread_rwlock_tryrdlock(&_lock);
 // 写-加锁
 pthread_rwlock_wrlock(&_lock);
 // 写-尝试加锁
 pthread_rwlock_trywrlock(&_lock);
 // 解锁
 pthread_rwlock_unlock(&_lock);
 // 销毁
 pthread_rwlock_destroy(&_lock);
 */

@interface FileRWDemo()
@property (nonatomic, assign) pthread_rwlock_t lock;
@end

@implementation FileRWDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化
        pthread_rwlock_init(&_lock, NULL);
    }
    return self;
}

- (void)otherTest {
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            [self read];
        });
        
        dispatch_async(queue, ^{
            [self write];
        });
    }
}

// 读操作，可以同时多个线程同时执行
- (void)read {
    pthread_rwlock_rdlock(&_lock);
    sleep(1);
    NSLog(@"%s", __func__);
    pthread_rwlock_unlock(&_lock);
    
}

// 写操作，一次只能一个线程执行。
- (void)write {
    pthread_rwlock_wrlock(&_lock);
    sleep(1);
    NSLog(@"%s", __func__);
    pthread_rwlock_unlock(&_lock);
}

- (void)dealloc
{
    pthread_rwlock_destroy(&_lock);
}

@end
