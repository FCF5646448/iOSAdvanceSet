//
//  BaseDemo.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "BaseDemo.h"

@interface BaseDemo()
@property (nonatomic, assign) int money;
@property (nonatomic, assign) int ticketsCount;
@end

@implementation BaseDemo

- (void)tickets {
    self.ticketsCount = 1000;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        for (int i=0; i<10; i++) {
            [self __saleTickets];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i=0; i<10; i++) {
            [self __saleTickets];
        }
    });
}

- (void)__saleTickets {
    int oldTickets = self.ticketsCount;
    sleep(.5);
    oldTickets -= 1;
    self.ticketsCount = oldTickets;
    NSLog(@"剩余%d张票",self.ticketsCount);
}


- (void)ATM {
    
    self.money = 1000;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i<10; i++) {
            [self __saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i<10; i++) {
            [self __drawMoney];
        }
    });
    
}

- (void)__saveMoney {
    int oldMoney = self.money;
    sleep(.5);
    
    oldMoney += 50;
    self.money = oldMoney;
//    NSLog(@"剩余%d元",self.money);
}

- (void)__drawMoney {
    int oldMoney = self.money;
    sleep(.5);
    
    oldMoney -= 50;
    self.money = oldMoney;
//    NSLog(@"剩余%d元",self.money);
}

- (void)otherTest {
    
}

@end
