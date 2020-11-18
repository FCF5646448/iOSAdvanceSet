//
//  PermenantThread.m
//  RunLoopDemo
//
//  Created by 冯才凡 on 2020/11/18.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "PermenantThread.h"

//重写一个Thread，主要是为了观察生命周期
@interface InsideThread : NSThread

@end

@implementation InsideThread

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end



@interface PermenantThread()
@property (strong, nonatomic) InsideThread * thread;
@property (nonatomic, assign) BOOL stoped;
@end

@implementation PermenantThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        __weak typeof(self) weakself = self;
        self.thread = [[InsideThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            
            while (weakself && !weakself.stoped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
        }];
        
        [self.thread start];
    }
    return self;
}

#pragma make - public方法
- (void)stop {
    if (!self.thread) {
        return;
    }
    [self performSelector:@selector(__stop) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)executeTaskBlock:(void (^)(void))task {
    if (!self.thread || !task) {
        return;
    }
    
    [self performSelector:@selector(__executeTast:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)dealloc
{
    [self stop];
}

#pragma make - 内部私有方法
- (void)__stop {
    self.stoped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)__executeTast:(void (^)(void))task {
    task();
}



@end


