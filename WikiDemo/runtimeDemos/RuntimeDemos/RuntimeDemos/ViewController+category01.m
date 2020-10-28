//
//  ViewController+category01.m
//  RuntimeDemos
//
//  Created by 冯才凡 on 2019/1/4.
//  Copyright © 2019年 冯才凡. All rights reserved.
//

#import "ViewController+category01.h"
#import <objc/runtime.h>
#import <objc/message.h>




@implementation ViewController (category01)
- (void)test{
    NSLog(@"ViewController (category01)");
}

static void * const kAssociatedObjcKey = "xxxxxx";
- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, kAssociatedObjcKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, kAssociatedObjcKey);
}

@end
