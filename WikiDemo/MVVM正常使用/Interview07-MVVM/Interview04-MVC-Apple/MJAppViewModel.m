//
//  MJAppViewModel.m
//  Interview04-MVC-Apple
//
//  Created by MJ Lee on 2018/7/17.
//  Copyright © 2018年 MJ Lee. All rights reserved.
//

#import "MJAppViewModel.h"
#import "MJApp.h"
#import "MJAppView.h"

@interface MJAppViewModel() <MJAppViewDelegate>
@property (weak, nonatomic) UIViewController *controller;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *image;
@end

@implementation MJAppViewModel

- (instancetype)initWithController:(UIViewController *)controller
{
    if (self = [super init]) {
        self.controller = controller;
        
        // 创建View
        MJAppView *appView = [[MJAppView alloc] init];
        appView.frame = CGRectMake(100, 100, 100, 150);
        appView.delegate = self;
        appView.viewModel = self;
        [controller.view addSubview:appView];
        
        // 加载模型数据
        MJApp *app = [[MJApp alloc] init];
        app.name = @"QQ";
        app.image = @"QQ";
        
        // 设置数据
        self.name = app.name;
        self.image = app.image;
    }
    return self;
}

#pragma mark - MJAppViewDelegate
- (void)appViewDidClick:(MJAppView *)appView
{
    NSLog(@"viewModel 监听了 appView 的点击");
}

@end
