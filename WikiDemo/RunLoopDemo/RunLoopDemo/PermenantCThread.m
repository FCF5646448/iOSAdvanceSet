//
//  PermenantCThread.m
//  RunLoopDemo
//
//  Created by 冯才凡 on 2020/11/18.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "PermenantCThread.h"

@interface PermenantCThread()
@property (nonatomic, strong) NSThread * thread;
@end

@implementation PermenantCThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.thread = [[NSThread alloc] initWithBlock:^{
            
            //创建上下文
            CFRunLoopSourceContext context = {0};
            
            //创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            
            //往RunLoop添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            
            //销毁source
            CFRelease(source);
            
            // 启动RunLoop，第三个参数表示执行完这一次source后是否退出当前loop，这里设置为false后，就可以不用像OC那样写一个while循序了。
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
        }];
        [self.thread start];
    }
    return self;
}

//结束一个线程
- (void)stop {
    if(!self.thread) return;
    [self performSelector:@selector(__stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

//执行任务
- (void)executeTaskBlock:(void (^)(void))task {
    if(!self.thread || !task) return;
    [self performSelector:@selector(__execute:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)dealloc
{
    [self stop];
    NSLog(@"%s", __func__);
}

- (void)__stop {
    if(!self.thread) return;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)__execute:(void (^)(void))task {
    task();
}

@end
