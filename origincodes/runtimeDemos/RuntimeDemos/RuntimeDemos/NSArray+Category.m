//
//  NSArray+Category.m
//  RuntimeDemos
//
//  Created by 冯才凡 on 2019/1/19.
//  Copyright © 2019年 冯才凡. All rights reserved.
//

#import "NSArray+Category.h"
#import <objc/runtime.h>

@implementation NSArray (Category)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
        Method newMethod    = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(msObjectAtIndex:));
        method_exchangeImplementations(originMethod, newMethod);
    });
}

- (id)msObjectAtIndex:(NSUInteger)index {
    if (self.count - 1 < index) {
        //越界了
        @try {
            return [self msObjectAtIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"%s crash cause method %s at %d\n",class_getName(self.class),__func__,__LINE__);
            NSLog(@"%@",[exception callStackSymbols]);
            return nil;
        } @finally {
            //
        }
    }else{
        return [self msObjectAtIndex:index];
    }
}
@end
