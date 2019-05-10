//
//  ViewReusePool.h
//  UI视图Demo
//
//  Created by 冯才凡 on 2019/5/10.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 实现重用机制的类
@interface ViewReusePool : NSObject
//取
- (UIView *)dequeuereusebleView;
//存
- (void)addUsingView:(UIView *)view;
//重置
- (void)reset;

@end

