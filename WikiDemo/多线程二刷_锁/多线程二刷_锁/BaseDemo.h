//
//  BaseDemo.h
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseDemo : NSObject


- (void)ATM;
- (void)tickets;
- (void)otherTest;

// 暴露3个方法给子类使用
- (void)__saleTickets;
- (void)__saveMoney;
- (void)__drawMoney;

@end

NS_ASSUME_NONNULL_END
