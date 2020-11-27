//
//  Person.m
//  内存管理二刷Demo
//
//  Created by 冯才凡 on 2020/11/27.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
