//
//  ViewController.m
//  多线程二刷Demo
//
//  Created by 冯才凡 on 2020/11/19.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, assign) NSInteger money;
@end

@implementation ViewController


//dispatch_sync和dispatch_async用来控制是否开启新线程
//队列类型决定任务执行方式：串行、并发。

- (void)viewDidLoad {
    [super viewDidLoad];
    self.money = 1000;
    [self interView10];
    
}


- (void) intervire0 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_sync(queue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"执行一次任务%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"2执行一次任务%@", [NSThread currentThread]);
        }
    });
}

// 问题1：以下任务能否正常执行，执行顺序是什么？
// 这里不能正常执行，会产生死锁，任务2和任务3处在队列的相互等待中。
- (void)interView01 {
    NSLog(@"任务1");
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 队列的特点：排队，FIFO，first in first out. 先进先出
    
    dispatch_sync(queue, ^{
        NSLog(@"任务2_%@", [NSThread currentThread]);
    });
    
    // dispatch_sync: 立马在当前线程执行任务，执行完毕才能往下执行。
    
    NSLog(@"任务3");
}

// 问题2：以下任务能否正常执行，执行顺序是什么？
// 可以正常执行，因为任务2不要求立马在线程中执行，所以这里它会先等待任务3执行完毕。
- (void)interView02 {
    NSLog(@"任务1");
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        NSLog(@"任务2_%@", [NSThread currentThread]);
    });
    
    // dispatch_async: 不要求立马在当前线程同步执行任务。
    
    NSLog(@"任务3");
}

// 问题3：以下任务能否正常执行，执行顺序是什么？
// 会产生死锁，串行队列任务一个个执行，然后同步执行得立即执行，所以任务3和任务4会相互等待，导致死锁。
- (void)interView03 {
    NSLog(@"任务1");
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSLog(@"任务2_%@", [NSThread currentThread]);
        //同步任务立马执行。
        dispatch_sync(queue, ^{
            NSLog(@"任务3_%@", [NSThread currentThread]);
        });
        NSLog(@"任务4_%@", [NSThread currentThread]);
    });
    
    NSLog(@"任务5");
}


- (void)interView04 {
    dispatch_queue_t queue1 = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue2 = dispatch_get_global_queue(0, 0);
    dispatch_queue_t queue3 = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue4 = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"%p,%p,%p,%p", queue1,queue2,queue3,queue4); //0x10ea2df00,0x10ea2df00,0x60000144dc00,0x60000144db00 前两个队列是同一个。
    
}


- (void)test {
    NSLog(@"test");
}

- (void)interView05 {
//    NSLog(@"1");
    //这个定时器任务可以直接执行，因为主线程的RunLoop是自动开启的。
//    [self performSelector:@selector(test) withObject:nil afterDelay:0];
//    NSLog(@"3");
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"4");
        //可以立即执行
//        [self performSelector:@selector(test) withObject:nil];
        // 带有afterDelay的API底层用到了NSTimer定时器，定时器是得添加到RunLoop里面工作。而子线程的RunLoop需要手动开起。
        [self performSelector:@selector(test) withObject:nil afterDelay:0];
        /*手动启动runloop 注意run方法只是调用了runMode:beforeDate:方法，添加事件源得另外方法添加，没有事件源，线程仍旧无法保活。这里能够使用run方法让线程保活是因为perform:afterDelay:方法本身就有一个定时器事件源，所以可以直接run开启。若把这行代码放到perform前面则同样无法执行perform的selector，因为那时没有事件源。
         */
//      [[NSRunLoop currentRunLoop] run];
        
        // 另外一种手动启动runloop的方式，先添加事件源，再开启runMode
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode]; //添加事件源source0
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]; //开启
        NSLog(@"5");
    });
}


- (void)interView06 {
    NSThread * thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
        // 手动开启runloop，让线程不要立即死掉，才能执行下面的perform UntilDone
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode]; //添加事件源
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]; //启动
//        这里不能直接用run方法，因为run方法只是调用了runMode，但是没有添加事件源，也可能无法执行下面的perform方法。之前的perform:afterDelay:方法是其本身就有一个定时器事件源，所以可以直接run开启。
//        [[NSRunLoop currentRunLoop] run];
    }];
    //
    [thread start]; //block立马执行
    
    /*
     这个UntilDone是指等thread里的block任务执行完成后才执行Selector。但是如果thread内部不开启runloop，thread就无法保活，当perform执行selector时，thread有可能会退出。
     只调用runloop的run方法有时也会报错： target thread exited while waiting for the perform'
     */
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:YES];
}

// 这里会产生死锁，当thread start的时候，
- (void)interView07 {
    NSLog(@"1");
    NSThread * thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"2");
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }];
    NSLog(@"3");
    // UntilDone 为YES就会产生死锁，为NO就可以正常运行。（PS：不是很明白）
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:YES];
    NSLog(@"4");
    [thread start];
}


// dispatch_group
- (void)interView08 {
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    //创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    //添加异步任务
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"任务1-%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"任务2-%@",[NSThread currentThread]);
        }
    });
    /*
     等前面的任务都执行完毕，就会自动执行以下任务。以下任务3和任务4也是交替执行。
     dispatch_group_notify里的queue，也可以换成其它的，比如如果要回到主线程中更新，那么这里的queue可以使用main。
     */
    dispatch_group_notify(group, queue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"任务3-%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, queue, ^{
        for (int i = 0; i<10; i++) {
            NSLog(@"任务4-%@",[NSThread currentThread]);
        }
    });
}

// 卖票
- (void)interView09 {
    
    [self saleTickits];
}

//卖票。
- (void)saleTickits {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i<5; i++) {
            [self saleTickit];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i<5; i++) {
            [self saleTickit];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i<5; i++) {
            [self saleTickit];
        }
    });
    
}

- (void)saleTickit {
    static int ticketsCount = 1000;
    
    int oldTicksCount = ticketsCount;
    
    sleep(.2);
    oldTicksCount--;
    
    ticketsCount = oldTicksCount;
    
    NSLog(@"还剩%d张票",ticketsCount);
}

// 存取钱
- (void)interView10 {
    
    [self ATM];
}

//ATM 存取钱
- (void)ATM {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i<5; i++) {
            [self saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i<5; i++) {
            [self drawMoney];
        }
    });
}

- (void)saveMoney {
    NSInteger oldMoney = self.money;
    
    sleep(.2);
    oldMoney += 50;
    
    self.money = oldMoney;
    
    NSLog(@"还剩%ld元",(long)self.money);
}

- (void)drawMoney {
    NSInteger oldMoney = self.money;
       
       sleep(.2);
       oldMoney -= 50;
       
       self.money = oldMoney;
       
       NSLog(@"还剩%ld元",(long)self.money);
}




@end
