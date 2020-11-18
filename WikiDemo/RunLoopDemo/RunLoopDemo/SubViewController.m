//
//  SubViewController.m
//  RunLoopDemo
//
//  Created by 冯才凡 on 2020/11/18.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "SubViewController.h"
#import "FCFThread.h"

@interface SubViewController ()
@property (nonatomic, strong) FCFThread * thread;
@property (nonatomic, assign) BOOL isStop;
@end

@implementation SubViewController

void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常驻线程";
    
    // 创建Observer
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, runLoopObserverCallBack, NULL);
//    // 添加observer
//    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
//    CFRelease(observer);
//
//
//    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^{
//        NSLog(@"给runloop添加block");
//    });
//
    
//    _thread = [[FCFThread alloc] initWithTarget:self selector:@selector(run) object:nil];
//    [_thread start];
    
    __weak typeof(self) weakself = self;
    //使用block不使用target，避免强引用target
    _thread = [[FCFThread alloc] initWithBlock:^{
        
            NSLog(@"begin__%@", [NSThread currentThread]);
           
           //添加了这句就可以让线程保活，不执行后面的end。
           [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        //不使用这个方法，因为它无法被Stop。
//           [[NSRunLoop currentRunLoop] run];
        
        while (weakself && !weakself.isStop) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
           
           NSLog(@"end__%@", [NSThread currentThread]);
    }];
    [_thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //每点击一次就执行一次任务。意味着经常要在子程序中执行任务，所以才要求最好保活线程。
    if (self.thread) {
        [self performSelector:@selector(task) onThread:_thread withObject:nil waitUntilDone:NO];
    }
}

// 子线程经常要执行的任务
- (void)task {
    NSLog(@"子线程经常要执行的任务%s %@", __func__, [NSThread currentThread]);
}

////这个方法就是在子线程开启的时候执行，为了开启runloop，保证子线程不退出
//- (void)run {
//    NSLog(@"%s %@", __func__, [NSThread currentThread]);
//
//    //添加了这句就可以让线程保活，不执行后面的end。
//    [[NSRunLoop currentRunLoop] addPort:[NSPort alloc] forMode:NSDefaultRunLoopMode];
//    [[NSRunLoop currentRunLoop] run];
//
//    NSLog(@"end");
//}

// 停止子线程的runloop
- (void)stopThread {
    //更改标记
    self.isStop = YES;
    
    //停止RunLoop(只能停止一次runMode:deforeDate,所以无法使用它停止RunLoop的run方法)
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    //清空线程
    self.thread = nil;
}

// 按钮模拟销毁子线程
- (IBAction)destroyThread:(id)sender {
    if (!self.thread) {
        return;
    }
    // 让销毁方法在子线程中执行，才能拿到子线程的runloop
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}

// 退出时销毁线程
- (void)dealloc
{
    [self destroyThread:nil];
}

@end
