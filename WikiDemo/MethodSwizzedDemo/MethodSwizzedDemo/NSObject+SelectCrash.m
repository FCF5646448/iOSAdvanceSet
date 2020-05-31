//
//  NSObject+SelectCrash.m
//  MethodSwizzedDemo
//
//  Created by 冯才凡 on 2020/5/31.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "NSObject+SelectCrash.h"
#import <objc/runtime.h>


@implementation NSObject (SelectCrash)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) {
        //已经实现不做处理
        return [self methodSignatureForSelector:aSelector];
    }
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"在 %@ 类中, 调用了没有实现的实例方法: %@ ",NSStringFromClass([self class]),NSStringFromSelector(anInvocation.selector));
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) {
        // 已实现不做处理
        return [self methodSignatureForSelector:aSelector];
    }
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}
+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"在 %@ 类中, 调用了没有实现的类方法: %@ ",NSStringFromClass([self class]),NSStringFromSelector(anInvocation.selector));
}


@end
