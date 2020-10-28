//
//  Share.m
//  NSTimer破除循环引用
//
//  Created by 冯才凡 on 2019/5/16.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "Share.h"

@interface Share()
@property (nonatomic, class, readonly) Share * shareInstance;
@end

@implementation Share
+ (instancetype)shareInstance {
    return [Share new];
}
@end
