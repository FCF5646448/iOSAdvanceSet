//
//  ViewReusePool.m
//  UI视图Demo
//
//  Created by 冯才凡 on 2019/5/10.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "ViewReusePool.h"

@interface ViewReusePool()
//等待使用的队列
@property (nonatomic, strong) NSMutableSet * waitUsedQueue;
//使用中的队列
@property (nonatomic, strong) NSMutableSet * usingQueue;
@end

@implementation ViewReusePool

- (instancetype)init
{
    self = [super init];
    if (self) {
        _waitUsedQueue = [NSMutableSet set];
        _usingQueue = [NSMutableSet set];
    }
    return self;
}


//取
- (UIView *)dequeuereusebleView {
    UIView * view = [_waitUsedQueue anyObject];
    if (view == nil) {
        return nil; //没有可重用的
    }else{
        //进行队列移动
        [_waitUsedQueue removeObject:view];
        [_usingQueue addObject:view];
        return view;
    }
}
//存
- (void)addUsingView:(UIView *)view {
    if (view == nil) {
        return;
    }
    [_usingQueue addObject:view];
}
//重置复用池
- (void)reset {
    UIView *view = nil;
    while ((view = [_usingQueue anyObject])) {
        //从使用队列中移除
        [_usingQueue removeObject:view];
        //添加进等待队列
        [_waitUsedQueue addObject:view];
    }
}

@end
