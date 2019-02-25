//
//  NSMutableArray+Category.m
//  RuntimeDemos
//
//  Created by 冯才凡 on 2019/2/25.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "NSMutableArray+Category.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Category)
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
        Method newMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(msObjectAtIndex:));
        
        Method originMethod0 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndexedSubscript:));
        Method newMethod0 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(msObjectAtIndexedSubscript:));
        
        method_exchangeImplementations(originMethod, newMethod);
        method_exchangeImplementations(originMethod0, newMethod0);
    });
}

- (id)msObjectAtIndex:(NSUInteger)index {
    if (self.count - 1 < index) {
        //越界了
        @try {
            return [self msObjectAtIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"越界了");
            NSLog(@"%@",[exception callStackSymbols]);
            return nil;
        } @finally {
            //
        }
    }else{
        return [self msObjectAtIndex:index];
    }
}

//使用下标越界调用的方法
- (id)msObjectAtIndexedSubscript:(NSUInteger)index {
    if (self.count - 1 < index) {
        //越界了
        @try {
            return [self msObjectAtIndexedSubscript:index];
        } @catch (NSException *exception) {
            NSLog(@"越界了");
            NSLog(@"%@",[exception callStackSymbols]);
            return nil;
        } @finally {
            //
        }
    }else{
        return [self msObjectAtIndexedSubscript:index];
    }
}

@end
