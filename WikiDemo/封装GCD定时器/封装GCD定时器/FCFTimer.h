//
//  FCFTimer.h
//  封装GCD定时器
//
//  Created by 冯才凡 on 2020/11/25.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCFTimer : NSObject

/*
 task: 定时器回调任务
 start: 延时多少秒开始执行
 interval： 每隔多少秒执行1次
 repeats: 是否重复
 async: 同步还是异步，YES就放到子线程执行，NO就放到主线程执行
 */
+ (NSString *)execTask:(void(^)(void)) task
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async;

+ (NSString *)execTask:(id)target
              selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async;

+ (void)cancelTask:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
