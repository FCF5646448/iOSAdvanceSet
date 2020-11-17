//
//  NSObject+Json.h
//  RunTimeAPI使用
//
//  Created by 冯才凡 on 2020/11/14.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Json)
+ (instancetype)fcf_objectWithJson:(NSDictionary *)json;
@end

NS_ASSUME_NONNULL_END
