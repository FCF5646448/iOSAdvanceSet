//
//  NSObject+Json.m
//  RunTimeAPI使用
//
//  Created by 冯才凡 on 2020/11/14.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "NSObject+Json.h"

#import <AppKit/AppKit.h>
#import <objc/runtime.h>


@implementation NSObject (Json)
+ (instancetype)fcf_objectWithJson:(NSDictionary *)json {
    id obj = [[self alloc] init];
    
    unsigned int count;
    Ivar * ivars = class_copyIvarList([self class], &count);
    for (int i=0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSMutableString * name = [NSMutableString stringWithUTF8String: ivar_getName(ivar)];
        [name deleteCharactersInRange:NSMakeRange(0, 1)];
        
        [obj setValue:json[name] forKey:name];
    }
    free(ivars);
    
    return obj;
}
@end
