//
//  Share.h
//  NSTimer破除循环引用
//
//  Created by 冯才凡 on 2019/5/16.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Share : NSObject
+ (instancetype)shareInstance;

@property (nonatomic, copy)NSString * str;

@end

NS_ASSUME_NONNULL_END
