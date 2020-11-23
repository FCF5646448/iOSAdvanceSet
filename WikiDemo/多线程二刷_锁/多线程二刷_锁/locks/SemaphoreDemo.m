//
//  SemaphoreDemo.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/22.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "SemaphoreDemo.h"

@interface SemaphoreDemo()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_semaphore_t ticketsemaphore;
@property (nonatomic, strong) dispatch_semaphore_t moneysemaphore;


@end

@implementation SemaphoreDemo


- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始值表示最大并发数量。类似NSOperation里的maxCount
        self.semaphore = dispatch_semaphore_create(5);
        self.ticketsemaphore = dispatch_semaphore_create(1);
        self.moneysemaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)otherTest {
    for (int i = 0; i<20; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
}

- (void)test {
    /*
     第二个参数是等待时间，DISPATCH_TIME_FOREVER是指永远等待。
     
     如果信号量的值 > 0, 就让信号量减1，然后继续执行后续代码。
     如果信号量的值 <= 0， 就会休眠等待。直到等待时间到了或信号量的值又大于0，才会继续接着执行后续代码。
     
     */
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    sleep(3);
    NSLog(@"%@", [NSThread currentThread]);
    
    // 让信号量的值 +1 。
    dispatch_semaphore_signal(self.semaphore);
}


- (void)__saleTickets {
    dispatch_semaphore_wait(self.ticketsemaphore, DISPATCH_TIME_FOREVER);
    [super __saleTickets];
    dispatch_semaphore_signal(self.ticketsemaphore);
}

- (void)__saveMoney {
    dispatch_semaphore_wait(self.ticketsemaphore, DISPATCH_TIME_FOREVER);
    [super __saveMoney];
    dispatch_semaphore_signal(self.ticketsemaphore);
    
}

- (void)__drawMoney {
    dispatch_semaphore_wait(self.ticketsemaphore, DISPATCH_TIME_FOREVER);
    [super __drawMoney];
    dispatch_semaphore_signal(self.ticketsemaphore);
    
}


@end
