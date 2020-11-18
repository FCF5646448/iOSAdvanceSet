//
//  PermenantThread.h
//  RunLoopDemo
//
//  Created by 冯才凡 on 2020/11/18.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PermenantThread : NSObject

//结束一个线程
- (void)stop;

//执行任务
- (void)executeTaskBlock:(void (^)(void))task;

@end

NS_ASSUME_NONNULL_END
