//
//  ViewController+Category2.m
//  MethodSwizzedDemo
//
//  Created by 冯才凡 on 2020/5/28.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ViewController+Category2.h"
#import <objc/runtime.h>

@implementation ViewController (Category2)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method m1 = class_getInstanceMethod([self class], @selector(test));
        Method m2 = class_getInstanceMethod([self class], @selector(categoryTest));
        
        method_exchangeImplementations(m1, m2);
    });
}

- (void)categoryTest {
    NSLog(@"category2Test");
}
@end
