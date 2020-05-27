//
//  ViewController+Category1.m
//  MethodSwizzedDemo
//
//  Created by 冯才凡 on 2020/5/28.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ViewController+Category1.h"
#import <objc/runtime.h>


@implementation ViewController (Category1)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method1 = class_getInstanceMethod([self class], @selector(test));
        Method method2 = class_getInstanceMethod([self class], @selector(categoryTest));

        method_exchangeImplementations(method1, method2);
    });
}

- (void)categoryTest {
    NSLog(@"category1Test");
}

@end
