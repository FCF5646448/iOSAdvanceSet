//
//  NSConditionLockDemo.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "NSConditionLockDemo.h"

/*
 NSConditionLock 是对NSCondition的封装。
 它可以添加某个条件值。1
 
 它可以在指定条件下进行加锁和解锁操作。通过条件的可以到达线程之间的相互依赖关系。
 
 
 API：
    initWithCondition：1 //后面跟随条件值，如果直接使用init方法，则默认条件值就是0.
    lockWhenCondition：1 //对条件值为1的锁进行加锁，
    unlockWithCondition：2 //对当前锁进行解锁，同时将条件值设置为2.
 
如果一开始不管它的条件值是什么，都想要执行加锁操作，那么执行lock就可以了；如果不管它的条件值是什么，都想执行解锁操作，那么执行unlock就可以了。
 
 */

@interface NSConditionLockDemo()
@property (nonatomic, strong) NSConditionLock *conditionLock;
@end

@implementation NSConditionLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化条件值是1，所以只有条件值是1的锁才能加锁成功。
        // 如果不去设置条件值的话，那么默认的条件值是0。
        self.conditionLock = [[NSConditionLock alloc] initWithCondition:1];
    }
    return self;
}

- (void)otherTest {
    //在不同的线程进行数组元素的删除和添加操作。
    [[[NSThread alloc] initWithTarget:self selector:@selector(__one) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(__two) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(__three) object:nil] start];
}

// 这样就能够让线程之间达到一种依赖，执行顺序必定是：__one ——> __two ——> __three
- (void)__one {
    
    [_conditionLock lockWhenCondition:1];
   
    sleep(1);
    NSLog(@"%s", __func__);
    
    [_conditionLock unlockWithCondition:2];
}

- (void)__two {
    [_conditionLock lockWhenCondition:2];
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    [_conditionLock unlockWithCondition:3];
}

- (void)__three {
    [_conditionLock lockWhenCondition:3];
    
    NSLog(@"%s", __func__);
    
    [_conditionLock unlock];
}
@end
