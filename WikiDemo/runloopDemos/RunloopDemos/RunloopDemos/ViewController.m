//
//  ViewController.m
//  RunloopDemos
//
//  Created by 冯才凡 on 2019/1/24.
//  Copyright © 2019年 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "CheckRunLoopController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtv;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (assign, nonatomic) NSInteger tick;
@property (strong, nonatomic) NSThread * thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"timer&thread";
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self begintime];
}

#pragma mark -- RunLoop 与 NSTimer
- (void)begintime {
    _tick = 0;
    NSTimer * timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];//如果这里是NSDefaultRunLoopMode，则滚动textview的时候，定时器不会走
}

- (void)timeTick {
    _tick += 1;
    _timelabel.text = [NSString stringWithFormat:@"%ld",_tick];
}


#pragma mark -- RunLoop 实现常驻线程
static BOOL runAlways = YES;
- (void)usethread {
    [self performSelector:@selector(subThreadRun) onThread:self.thread withObject:nil waitUntilDone:NO];
}

//线程安全的方式创建thread
- (NSThread *)thread {
    if (_thread == nil) {
        @synchronized (self) {
            _thread = [[NSThread alloc] initWithTarget:self selector:@selector(runThread) object:nil];
            [_thread setName:@"com.fcf.thread"];
            [_thread start];// 启动
        }
    }
    return _thread;
}

- (void)runThread {
    // https://www.jianshu.com/p/7eaedfc8f8f6
    //方法一：创建一个可控的runloop
    //创建一个source
    CFRunLoopSourceContext context = {0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);

    //创建runloop，同时向runloop的defaultmode添加source CFRunLoopGetCurrent类似懒加载方法
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);

    while (runAlways) {
        @autoreleasepool {
            //将当前runloop运行在kCFRunLoopDefaultMode下
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
        }
    }

    //当runaway为NO时跳出runloop，线程退出
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
    
    //方法一：创建一个一直存在的runloop
//    @autoreleasepool {
//        NSRunLoop * runloop = [NSRunLoop currentRunLoop];
//        [runloop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
//        NSLog(@"启动RunLoop前--%@",runloop.currentMode);
//        [runloop run];
//    }
    
}

- (void) subThreadRun {
    NSLog(@"启动RunLoop后--%@",[NSRunLoop currentRunLoop].currentMode);
    NSLog(@"%@----子线程任务开始",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"%@----子线程任务结束",[NSThread currentThread]);
}

//检测卡顿
- (IBAction)jumpToCheckRunloop:(id)sender {
    CheckRunLoopController * vc = [CheckRunLoopController loadFromNib];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
