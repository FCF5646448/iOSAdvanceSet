//
//  Student.m
//  面试题测试
//
//  Created by 冯才凡 on 2019/11/28.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "Student.h"

@implementation Student
- (instancetype) init {
    if (self = [super init]) {
        NSLog(@"[self class] = %@",[self class]);
        NSLog(@"[super class] = %@",[super class]);
        NSLog(@"[self superclass] = %@",[self superclass]);
        NSLog(@"[super superclass] = %@",[super superclass]);
    }
    return self;
}
@end
