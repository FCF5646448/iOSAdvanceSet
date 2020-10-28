//
//  CheckRunLoopController.m
//  RunloopDemos
//
//  Created by 冯才凡 on 2019/2/18.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "CheckRunLoopController.h"
#import "ImagesCell.h"
#import "CheckBlockManager.h"

@interface CheckRunLoopController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CheckRunLoopController

+ (instancetype)loadFromNib {
    CheckRunLoopController * vc = [[[NSBundle mainBundle] loadNibNamed:@"CheckRunLoopController" owner:self options:nil] firstObject];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"ImagesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ImagesCell"];
    _tableView.rowHeight = 120;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(stopMonitor)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[CheckBlockManager shareInstance] startWithInterval:0.01 fault:0.01];
    [_tableView reloadData];
}

- (void)stopMonitor {
    [[CheckBlockManager shareInstance] stop];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImagesCell" forIndexPath:indexPath];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"01" ofType:@"jpg"];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    cell.img1.image = img;
    cell.img2.image = img;
    cell.img3.image = img;
    NSLog(@"%@",[NSRunLoop currentRunLoop].currentMode);
    
    return cell;
}


@end
