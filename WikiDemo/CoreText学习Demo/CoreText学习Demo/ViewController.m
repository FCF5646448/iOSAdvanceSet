//
//  ViewController.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/15.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "TextView.h"
#import "ImageView.h"
#import "ImageTextDataCreator.h"
#import "GestureView.h"
#import "TruncationView.h"
#import "FontView.h"
#import "AutoLayoutView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self drawText];
//    [self drawImageAndText];
//    [self drawGestureView];
//    [self truncationView];
//    [self fontView];
    [self autolayout];
}

// 测试纯文本
- (void)drawText {
    TextView * v = [[TextView alloc] initWithFrame:(CGRect){0,0,self.view.bounds.size.width, 200}];
    [self.view addSubview:v];
    v.backgroundColor = [UIColor whiteColor];
}

// 测试图文混排
- (void)drawImageAndText {
    CGRect frame = (CGRect){0, 100, self.view.bounds.size.width, 400};
    ImageView * v = [[ImageView alloc] initWithFrame:frame];
    v.data = [[[ImageTextDataCreator alloc] init] imagetextDataWithhFrame:frame];
    [self.view addSubview:v];
    v.backgroundColor = [UIColor grayColor];
    
}

// 测试手势
- (void)drawGestureView {
    CGRect frame = (CGRect){0, 60, self.view.bounds.size.width, 600};
    GestureView * v = [[GestureView alloc] initWithFrame:frame];
    [self.view addSubview:v];
    v.backgroundColor = [UIColor grayColor];
}

// 测试段落阶段
- (void)truncationView {
    CGRect frame = (CGRect){0, 60, self.view.bounds.size.width, 600};
    TruncationView * v = [[TruncationView alloc] initWithFrame:frame];
    [self.view addSubview:v];
    v.backgroundColor = [UIColor grayColor];
}

// 测试各种字体
- (void)fontView {
    CGRect frame = (CGRect){0, 60, self.view.bounds.size.width, 600};
    FontView * v = [[FontView alloc] initWithFrame:frame];
    [self.view addSubview:v];
    v.backgroundColor = [UIColor grayColor];
}

// 测试AutoLayout
- (void)autolayout {
    CGRect frame = (CGRect){0, 60, self.view.bounds.size.width, 600};
    AutoLayoutView * v = [[AutoLayoutView alloc] initWithFrame:frame];
    [self.view addSubview:v];
    v.backgroundColor = [UIColor grayColor];
}


@end
