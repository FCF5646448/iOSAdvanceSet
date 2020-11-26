//
//  Person.m
//  内存管理二刷_MRC
//
//  Created by 冯才凡 on 2020/11/26.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)setDog:(Dog *)dog {
    if (_dog != dog) {
        [_dog release];
        _dog = [dog retain];
    }
}

- (Dog *)dog {
    return _dog;
}
- (void)dealloc
{
    // 下面两句也可以直接调用：self.dog = nil; 相当于调用set方法。
    [_dog release];
    _dog = nil;

    NSLog(@"%s", __func__);
    [super dealloc];
}
@end
