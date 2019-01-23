//
//  ORMTestObjc.m
//  RuntimeDemos
//
//  Created by 冯才凡 on 2019/1/22.
//  Copyright © 2019年 冯才凡. All rights reserved.
//

#import "ORMTestObjc.h"
#import <objc/runtime.h>

@implementation ORMTestObjc
+ (instancetype)objectWithDict:(NSDictionary *)dict {
    return [[ORMTestObjc alloc] initWithObjct:dict];
}

- (instancetype)initWithObjct:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        //获取实例对象属性列表和协议属性列表
        unsigned int count = 0;
        // 获取属性列表
        objc_property_t * propertyLists = class_copyPropertyList([self class], &count);
        for (int i=0; i<count; i++) {
            const char * name = property_getName(propertyLists[i]);
            NSString * nameStr = [[NSString alloc] initWithUTF8String:name];
            id value = [dict objectForKey:nameStr];
            [self setValue:value forKey:nameStr];
        }
        free(propertyLists);
    }
    return self;
}
@end
