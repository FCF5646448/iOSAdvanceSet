//
//  FIleRWDemo2.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/23.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "FIleRWDemo2.h"

/*
 //栅栏调用
 dispatch_barrier_async
 
 
 
 //
 
 */
@interface FIleRWDemo2()
@property (strong, nonatomic) dispatch_queue_t queue;
@end

@implementation FIleRWDemo2

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化 栅栏调用，必须是自定义的并发队列
        _queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)otherTest {
    
    //从打印的时间可以看出。读是同时进行的，写是一个个执行
    for (int i = 0; i < 2; i++) {
        [self read];
        [self read];
        [self read];
        [self read];
        [self write];
        [self write];
        [self write];
    }
}

// 读操作，可以同时多个线程同时执行
- (void)read {
    
    dispatch_async(self.queue, ^{
        sleep(1);
        NSLog(@"%s", __func__);
    });
    
}

// 写操作，一次只能一个线程执行。
- (void)write {
    dispatch_barrier_async(self.queue, ^{
        sleep(1);
        NSLog(@"%s", __func__);
    });
    
}


@end
