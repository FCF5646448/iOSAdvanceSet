//
//  SerialAQueueDemo.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "SerialAQueueDemo.h"


/*

 因为串行队列是任务一个一个派发，等到前面的任务执行完成后才会派发新的任务。
 
 
 */


@interface SerialAQueueDemo()
@property (nonatomic, strong) dispatch_queue_t ticketQueue;
@property (nonatomic, strong) dispatch_queue_t moneyQueue;
@end

@implementation SerialAQueueDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ticketQueue = dispatch_queue_create("ticketQueue", DISPATCH_QUEUE_SERIAL);
        self.moneyQueue = dispatch_queue_create("moneyQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)__saleTickets {
    dispatch_sync(self.ticketQueue, ^{
        [super __saleTickets];
    });
}

- (void)__saveMoney {
    dispatch_sync(self.moneyQueue, ^{
        [super __saveMoney];
    });
}

- (void)__drawMoney {
    dispatch_sync(self.moneyQueue, ^{
        [super __drawMoney];
    });
}

@end
