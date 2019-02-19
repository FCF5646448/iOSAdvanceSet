//
//  CheckBlockManager.h
//  RunloopDemos
//
//  Created by 冯才凡 on 2019/2/18.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckBlockManager : NSObject

+(instancetype)shareInstance;

//开始监控
- (void)start;

//开始监控
- (void)startWithInterval:(NSTimeInterval)interval fault:(NSTimeInterval)fault;

// 停止监控
- (void)stop;

@end

NS_ASSUME_NONNULL_END
