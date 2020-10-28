//
//  CheckBlockManager.m
//  RunloopDemos
//
//  Created by 冯才凡 on 2019/2/18.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "CheckBlockManager.h"
#import <CrashReporter/CrashReporter.h> //打印crash的第三方framework


/* 往主线程runloop添加observer，以监听主线程的runloop周期变化
 * 往子线程添加定时器，以每隔一段时间检测耗时时长
 */

@interface CheckBlockManager()
@property (nonatomic, strong) NSThread                  *monitorThread; //监控线程
@property (nonatomic, assign) CFRunLoopObserverRef      observer;//观察者
@property (nonatomic, assign) CFRunLoopTimerRef         timer; //定时器

@property (nonatomic, strong) NSDate                    *startDate; //开始执行时间
@property (nonatomic, assign) BOOL                      excuting; //执行时长

@property (nonatomic, assign) NSTimeInterval            interval; //定时器间隔时长
@property (nonatomic, assign) NSTimeInterval            fault;    //卡顿阈值

@end

@implementation CheckBlockManager

static CheckBlockManager * _instance = nil;
+(instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [CheckBlockManager new];
        _instance.monitorThread = [[NSThread alloc] initWithTarget:self selector:@selector(monitorThreadEntryPoint) object:nil];
        
        [_instance.monitorThread start];
    });
    return _instance;
}

+ (void)monitorThreadEntryPoint {
    //开启常驻线程
    @autoreleasepool {
        [[NSThread currentThread] setName:@"CheckBlockManager"];
        NSRunLoop * runloop = [NSRunLoop currentRunLoop];
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runloop run];
    }
}

// 开始监控
- (void)start {
    [self startWithInterval:1.0 fault:2.0];
}

// 往主线程runloop添加observer，以监听主线程的runloop周期变化
//开始监听 interval：定时器间隔时长  fault：卡顿阈值
- (void)startWithInterval:(NSTimeInterval)interval fault:(NSTimeInterval)fault {
    _interval = interval;
    _fault = fault;
    
    if (_observer) {
        return;
    }
    
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        NULL,
        NULL,
        NULL
    };
    
    _observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                        kCFRunLoopAllActivities,
                                        YES,
                                        0,
                                        &runloopCallBack,
                                        &context);
    
    //将obverse添加到主线程的runloop中
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    
    //创建timer，并添加到子线程的runloop中
    [self performSelector:@selector(addTimerToMonitorThread) onThread:self.monitorThread withObject:nil waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
    
    
}

// 往子线程添加定时器，以每隔一段时间检测耗时时长
- (void)addTimerToMonitorThread {
    if (_timer) {
        return;
    }
    //创建timer
    CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext context = {0,(__bridge void*)self,NULL,NULL,NULL};
    _timer = CFRunLoopTimerCreate(kCFAllocatorDefault,
                                  0.1,
                                  _interval,
                                  0,
                                  0,
                                  &runloopTimerCallBack,
                                  &context);
    CFRunLoopAddTimer(currentRunLoop, _timer, kCFRunLoopCommonModes);
    
}

- (void)removeTimer {
    if (_timer) {
        CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
        CFRunLoopRemoveTimer(currentRunLoop, _timer, kCFRunLoopCommonModes);
        CFRelease(_timer);
        _timer = NULL;
    }
}

- (void)stop {
    if (_observer) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
        CFRelease(_observer);
        _observer = NULL;
    }
    [self performSelector:@selector(removeTimer) onThread:self.monitorThread withObject:nil waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
}

//调用第三方打印卡顿信息
- (void)handleStackInfo {
    //打印
    NSData * lagData = [[[PLCrashReporter alloc] initWithConfiguration:[[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll]] generateLiveReport];
    PLCrashReport *lagReport = [[PLCrashReport alloc] initWithData:lagData error:NULL];
    NSString * lagReportString = [PLCrashReportTextFormatter stringValueForCrashReport:lagReport withTextFormat:PLCrashReportTextFormatiOS];
    
    //
    NSLog(@"%@",lagReportString);
}
//监听runloop
static void runloopCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    CheckBlockManager * monitor = (__bridge CheckBlockManager*)info;
    NSLog(@"mainrunloop --- %@",[NSThread currentThread]);
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            monitor.startDate = [NSDate date];
            monitor.excuting = YES;
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            monitor.excuting = NO;
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
        default:
            break;
    }
}

//监听timer
static void runloopTimerCallBack(CFRunLoopTimerRef timer, void *info) {
    CheckBlockManager * monitor = (__bridge CheckBlockManager*)info;
    if (!monitor.excuting) {
        return;
    }
    
    //如果主线程正在执行任务，并且这一次loop执行到现在还没执行完，那就需要计算时间差
    NSTimeInterval excuteTime = [[NSDate date] timeIntervalSinceDate:monitor.startDate];
    NSLog(@"定时器 -- %@",[NSThread currentThread]);
    NSLog(@"主线程执行了-- %f s",excuteTime);
    if (excuteTime >= monitor.fault) {
        NSLog(@"线程卡顿了%f秒",excuteTime);
        [monitor handleStackInfo];
    }
}


@end
