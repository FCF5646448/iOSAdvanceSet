//
//  MutexDemo3.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "MutexDemo3.h"
#import <pthread.h>
/*
 pthread_cond_t 条件
 
 API：
 pthread_cond_init(&_cond, NULL);  // 创建线程条件。
 pthread_cond_wait(&_cond, &_mutex); //等待，等待的过程中会先将锁进行解锁，以便其他线程可以继续使用。然后当前线程进入等待状态。当接收到signal的信号后，则会重新对_mutex进行解锁。然后继续执行后续操作。
 
 
 pthread_cond_signal(&_cond);   // 信号， 唤醒一个等待该条件的线程。
 
 pthread_cond_broadcast(&_cond); // 广播 唤醒所有使用_cond的线程。
 
 pthread_cond_destroy(&_cond); // 销毁条件
 
 使用场景：
 1、这种情况就有点类似线程依赖。两个线程的执行顺序和开启时机是不确定的，在线程A中执行某个任务的时候，有可能要依赖线程B的某个任务的结果。所以就可以使用这种线程依赖来处理。
 2、例子：生成者-消费者模式：两个线程，线程A负责出售产品，线程B负责生产产品。当线程A开启出售的时候，有可能还没有生产出产品，所以就需要先进行等待。当线程B中生产出了产品后，线程A就可以进行售卖。所以就可以使用条件锁进行这种依赖操作。
 
 
 
 */


@interface MutexDemo3()
@property (nonatomic, assign) pthread_mutex_t mutex;
@property (nonatomic, assign) pthread_cond_t cond; //条件
@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation MutexDemo3

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //初始化属性
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        //设置类型
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
        //初始化锁
        pthread_mutex_init(&_mutex, &attr);
        // 销毁属性
        pthread_mutexattr_destroy(&attr);
        
        self.arr = [NSMutableArray array];
        
        // 创建条件
        pthread_cond_init(&_cond, NULL);
        
    }
    return self;
}

- (void)otherTest {
    //在不同的线程进行数组元素的删除和添加操作。
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    sleep(1);
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}


- (void)__remove {
    
    pthread_mutex_lock(&_mutex);
    NSLog(@"remove -- begin");
    
    if (self.arr.count == 0) {
        //进行等待，等待的过程中会先将当前锁进行解锁，以便其他线程可以获取到锁（肯定是等着加锁的线程）。然后当前线程进入等待。当接收到signal的信号或者broadcast通知后，会唤醒当前线程，只是并不会立马执行，而是也要看当前锁是否被其他线程解锁（也就是要进行加锁操作），如果当前锁还未解锁，则需要继续等待。等到锁被解锁之后，则会重新对_mutex进行解锁。然后继续执行后续操作。直到后面执行完成后解锁。这样整体上就是一个加解锁的平衡。
        pthread_cond_wait(&_cond, &_mutex);
    }
    
    [self.arr removeLastObject];
    NSLog(@"删除了元素");
    
    pthread_mutex_unlock(&_mutex);
}

- (void)__add {
    // 这里要加锁成功，则必须是当前锁处于解锁的状态。如果remove函数比add函数先执行，则这里加锁必定是先等到remove函数解锁之后，也就是remove函数里的unlock或者wait函数。
    pthread_mutex_lock(&_mutex);
    
    sleep(1);
    
    [self.arr addObject:@"test"];
    NSLog(@"添加了元素");
    
    // 信号， 唤醒一个等待该条件的线程。
    pthread_cond_signal(&_cond);
    // 广播 唤醒所有使用_cond的线程。
//    pthread_cond_broadcast(&_cond);
    //这里睡眠了1秒，也就是当前锁依旧没有解锁，所以接收到signal的wait也不会立马开始执行，而是要等待到后面解锁之后执行。
    sleep(1);
    
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc
{
    // 销毁锁
    pthread_mutex_destroy(&_mutex);
    // 销毁条件
    pthread_cond_destroy(&_cond);
}

@end
