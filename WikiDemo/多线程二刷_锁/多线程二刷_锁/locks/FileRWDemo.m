//
//  FileRWDemo.m
//  多线程二刷_锁
//
//  Created by 冯才凡 on 2020/11/23.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "FileRWDemo.h"

@interface FileRWDemo()
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@end

@implementation FileRWDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化信号值，设置一次最多只能有一个线程对其进行访问。
        self.semaphore = dispatch_semaphore_create(1);
        
    }
    return self;
}

- (void)otherTest {
    for (int i = 0; i < 10; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(read) object:nil] start];
        [[[NSThread alloc] initWithTarget:self selector:@selector(write) object:nil] start];
    }
}

- (void)read {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"%s", __func__);
    dispatch_semaphore_signal(self.semaphore);
}

- (void)write {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"%s", __func__);
    dispatch_semaphore_signal(self.semaphore);
}

@end
