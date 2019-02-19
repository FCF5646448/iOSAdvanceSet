//
//  TestTableController.m
//  RunloopDemos
//
//  Created by 冯才凡 on 2019/1/31.
//  Copyright © 2019年 冯才凡. All rights reserved.
//

#import "TestTableController.h"
#import "ImgsCell.h"


typedef void(^RunLoopTask)(void);

@interface TestTableController ()
@property (nonatomic, strong)NSMutableArray * dataSource;
//用来存放任务的数组
@property (nonatomic, strong) NSMutableArray<RunLoopTask> *tasks;
//最大任务数量
@property (nonatomic, assign) NSInteger maxTaskCount;

@property (nonatomic, assign) BOOL useRunloop;//

@end

@implementation TestTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优化TB";
    _dataSource = [NSMutableArray array];
    _tasks = [NSMutableArray array];
    _maxTaskCount = 30; //一般是初始化cell的个数。
    _useRunloop = YES;
    
    self.tableView.rowHeight = 80;
    self.tableView.tableFooterView = [UIView new];
    
    //添加定时器，使每个时间间隔定时唤醒runloop。
    CADisplayLink * displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeMethod)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    
    [self addRunLoopObserver];
    [self createDate];
}

- (void)timeMethod {
    //什么都不做
}

- (void)createDate {
//    [_dataSource addObject:@"01"];
//    [_dataSource addObject:@"02"];
//    [_dataSource addObject:@"rose"];
//    [_dataSource addObject:@"04"];
//    [_dataSource addObject:@"05"];
//    [_dataSource addObject:@"06"];
//    [_dataSource addObject:@"rose"];
//    [_dataSource addObject:@"rose"];
//    [_dataSource addObject:@"09"];
//    [_dataSource addObject:@"rose"];
//    [_dataSource addObject:@"01"];
//    [_dataSource addObject:@"02"];
//    [_dataSource addObject:@"rose"];
//    [_dataSource addObject:@"04"];
//    [_dataSource addObject:@"05"];
//    [_dataSource addObject:@"06"];
//    [_dataSource addObject:@"rose"];
//    [_dataSource addObject:@"rose"];
//    [_dataSource addObject:@"09"];
//    [_dataSource addObject:@"rose"];
//    [_dataSource addObject:@"01"];
//    [_dataSource addObject:@"02"];
//    [_dataSource addObject:@"rose"];
//    [_dataSource addObject:@"04"];
//    [_dataSource addObject:@"05"];
//    [_dataSource addObject:@"06"];
//    [_dataSource addObject:@"rose"];
//    [_dataSource addObject:@"rose"];
//    [_dataSource addObject:@"09"];
//    [_dataSource addObject:@"rose"];
    
    [self.tableView reloadData];
}

- (void)addRunLoopObserver {
    /* CFRunLoopAddObserver 注册runloop观察者函数，三个参数分别是currentrunloop、observer、mode
     * CFRunLoopObserverCreateWithHandler 创建观察者函数，kCFRunLoopBeforeWaiting,表示监听runloop即将切到内核态的通知，也可以监听所有通知kCFRunLoopAllActivities。
     *
     */
    
    
    //获取当前的runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //定义一个context
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    //定义一个观察者
    static CFRunLoopObserverRef defaultModeObserver;
    //创建观察者
    defaultModeObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                  kCFRunLoopBeforeWaiting,
                                                  YES,
                                                  0,
                                                  &CallBack,
                                                  &context);
    //添加观察者
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopDefaultMode);
    //
    CFRelease(defaultModeObserver);
    
//    //每16.7ms会执行一次
//    __weak typeof(self) weakself = self;
//    CFRunLoopAddObserver(CFRunLoopGetCurrent(), CFRunLoopObserverCreateWithHandler(nil, kCFRunLoopBeforeWaiting, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        //
//        if (weakself.tasks.count == 0) {
//            return ;
//        }
//        // 这样每一次都会把所有task都执行一遍
//        while (weakself.tasks.count > 0) {
//            RunLoopTask task = [weakself.tasks objectAtIndex:0];
//            //执行
//            task();
//            //执行完移除
//            [self.tasks removeObjectAtIndex:0];
//        }
//    }), kCFRunLoopDefaultMode);
    
}

static void CallBack(CFRunLoopObserverRef bserver, CFRunLoopActivity activity,void * info) {
    TestTableController * vcself = (__bridge TestTableController *)info;
    if (vcself.tasks.count == 0) {
        return;
    }
    RunLoopTask task = vcself.tasks.firstObject;
    if (task) {
        task();
    }
    [vcself.tasks removeObjectAtIndex:0];
}

//添加任务到数组
- (void)addTask:(RunLoopTask)task{
    //保存新任务
//    if (self.tasks.count < _maxTaskCount) {
//        [self.tasks addObject:task];
//    }
    [self.tasks addObject:task];

    //保证之前没来得及显示的图片不会再绘制
    if (self.tasks.count > _maxTaskCount) {
        [self.tasks removeObjectAtIndex:0];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_useRunloop) {
        return [self loadCellWithRunLoop:tableView atIndexPath:indexPath];
    }else{
        return [self loadNormalCell:tableView atIndexPath:indexPath];
    }
}


- (UITableViewCell *)loadCellWithRunLoop:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    ImgsCell *cell = [ImgsCell cellWithTableView:tableView];
    cell.img1.image = nil;
    cell.img2.image = nil;
    cell.img3.image = nil;
    __weak typeof(self) weakself = self;
    [self addTask:^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"01" ofType:@"jpg"];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        cell.img1.image = img;
    }];
    [self addTask:^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"02" ofType:@"jpg"];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        cell.img2.image = img;
    }];
    [self addTask:^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"03" ofType:@"jpg"];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        cell.img3.image = img;
    }];
    
    return cell;
}

- (UITableViewCell *)loadNormalCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    ImgsCell *cell = [ImgsCell cellWithTableView:tableView];
    
    NSString * url = self.dataSource[indexPath.row];
    NSString *path = [[NSBundle mainBundle] pathForResource:url ofType:@"jpg"];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    cell.img1.image = img;
    cell.img2.image = img;
    cell.img3.image = img;
    NSLog(@"%@",[NSRunLoop currentRunLoop].currentMode);
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
