//
//  FCFTimer.m
//  封装GCD定时器
//
//  Created by 冯才凡 on 2020/11/25.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "FCFTimer.h"

@interface FCFTimer()

@end

@implementation FCFTimer

static NSMutableDictionary * timeMap;
dispatch_semaphore_t semaphore;

+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timeMap = [NSMutableDictionary dictionary];
        semaphore = dispatch_semaphore_create(1);
    });
    
    
}

+ (NSString *)execTask:(void(^)(void)) task
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async {
    
    if (!task || start < 0 || (interval <= 0 && repeats)) {
        return nil;
    }
    
    // 创建队列
    dispatch_queue_t queue = async
    ? dispatch_queue_create("timer_queue", DISPATCH_QUEUE_SERIAL)
    : dispatch_get_main_queue();
    
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置时间
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC,
                              0);
    
    // 加锁
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    // 创建任务标识
    NSString * name = [NSString stringWithFormat:@"%zd", timeMap.count];
    // 存放到字典中
    timeMap[name] = timer;
    
    // 解锁
    dispatch_semaphore_signal(semaphore);
    
    
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            // 如果不重复，则执行1次就取消
            [self cancelTask:name];
        }
    });
    
    // 启动
    dispatch_resume(timer);
    
    
    
    return name;
}


+ (NSString *)execTask:(id)target
              selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async {
    if (!target || !selector) {
        return nil;
    }
    
    return [self execTask:^{
        if ([target respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
        }
    } start:start interval:interval repeats:repeats async:async];
}

// 取消
+ (void)cancelTask:(NSString *)name {
    if (name.length == 0) {
        return;
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timeMap[name];
    if (timer) {
        dispatch_source_cancel(timer);
        [timeMap removeObjectForKey:name];
    }
    dispatch_semaphore_signal(semaphore);
    
}


@end
