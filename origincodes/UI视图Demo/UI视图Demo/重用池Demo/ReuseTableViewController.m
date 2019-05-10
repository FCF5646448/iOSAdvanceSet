//
//  ReuseTableViewController.m
//  UI视图Demo
//
//  Created by 冯才凡 on 2019/5/10.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "ReuseTableViewController.h"
#import "IndexdTableView.h"

@interface ReuseTableViewController ()<UITableViewDelegate,UITableViewDataSource,IndexdTableViewDataSource>
@property (nonatomic, strong) IndexdTableView * table;
@property (nonatomic, strong) UIButton * btn;
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@end

@implementation ReuseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];
    
    _table = [[IndexdTableView alloc] initWithFrame:(CGRect){0,60,self.view.frame.size.width,self.view.frame.size.height - 60} style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.indexedDataSource = self;
    [self.view addSubview:_table];
    
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setFrame:(CGRect){0,20,self.view.frame.size.width,40}];
    _btn.backgroundColor = [UIColor redColor];
    [_btn setTitle:@"reloadTB" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(reloadTBAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
    for (int i = 0; i < 100; i++) {
        [_dataSource addObject:@(i+1)];
    }
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _table.frame = (CGRect){0,60,self.view.frame.size.width,self.view.frame.size.height - 60};
}



- (void)reloadTBAction {
    [self.table reloadData];
}

- (NSArray<NSString *> *)indexTitlesForIndexTableView:(UITableView *)tableView {
    static BOOL change = NO;
    if (change) {
        change = NO;
        return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    }else{
        change = YES;
        return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * indentifier = @"reuseId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.textLabel.text = [[_dataSource objectAtIndex:indexPath.row] stringValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

@end
