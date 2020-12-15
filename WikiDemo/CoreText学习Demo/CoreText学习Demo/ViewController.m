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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self drawText];
    [self drawImageAndText];
}


- (void)drawText {
    TextView * v = [[TextView alloc] initWithFrame:(CGRect){0,0,self.view.bounds.size.width, 200}];
    [self.view addSubview:v];
    v.backgroundColor = [UIColor whiteColor];
}

- (void)drawImageAndText {
    CGRect frame = (CGRect){0, 100, self.view.bounds.size.width, 400};
    ImageView * v = [[ImageView alloc] initWithFrame:frame];
    v.data = [[[ImageTextDataCreator alloc] init] imagetextDataWithhFrame:frame];
    [self.view addSubview:v];
    v.backgroundColor = [UIColor grayColor];
    
}


@end
