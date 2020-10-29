//
//  FCFPerson.m
//  BlockDemo
//
//  Created by 冯才凡 on 2020/10/29.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "FCFPerson.h"

@implementation FCFPerson

/*
 下面函数的编译结果:
 static void _I_FCFPerson_test(FCFPerson * self, SEL _cmd) {...}
 block的编译结果是:
 struct __FCFPerson__test_block_impl_0 {
   struct __block_impl impl;
   struct __FCFPerson__test_block_desc_0* Desc;
   FCFPerson *self; //捕获
   __FCFPerson__test_block_impl_0 ...
 };
 从函数的编译结果可知self也是一个参数，所以它也是一个局部变量。所以self也被捕获了。而block内部使用当前类的_name成员变量，实际也是先捕获self，然后通过self->_name来获取到成员变量的。如果是self.name，这里实际是编译成objc_msgSend,调用getter方法。
 */
- (void)test {
    void (^block)(void) = ^{
        NSLog(@"------------%p", self);
        NSLog(@"------------%p", self->_name);
        NSLog(@"------------%p", self.name);
    };
    block();
}

- (void)dealloc {
    NSLog(@"FCFPerson dealloc");
}
@end
