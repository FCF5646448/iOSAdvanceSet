//
//  NSConditionDemo.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "NSConditionDemo.h"


/*
 NSCondition是对pthread_mutex_t和pthread_cond_t的封装。可查看MutexDemo3
 
 */

@interface NSConditionDemo()
@property (nonatomic, strong) NSCondition *condition;
@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation NSConditionDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.condition = [[NSCondition alloc] init];
        self.arr = [NSMutableArray array];
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
    
    [_condition lock];
    NSLog(@"remove -- begin");
    
    if (self.arr.count == 0) {
        [self.condition wait];
    }
    
    [self.arr removeLastObject];
    NSLog(@"删除了元素");
    
    [_condition unlock];
}

- (void)__add {
    [_condition lock];
    
    sleep(1);
    
    [self.arr addObject:@"test"];
    NSLog(@"添加了元素");
    
    [self.condition signal];
    
    [_condition unlock];
}

@end
