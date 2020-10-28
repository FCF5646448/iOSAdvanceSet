//
//  ViewController.m
//  iOS 底层实现Demos
//
//  Created by 冯才凡 on 2019/11/21.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "ViewController.h"

#import "SubController2.h"

#import "FCFNotificationCerter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificate:) name:@"test" object:nil];
    
    
    [[FCFNotificationCerter defaultCenter] addObserver:self selector:@selector(notificate:) name:@"test" object:nil];
    
    
}

- (IBAction)btn1Action:(id)sender {
    SubController2 * vc =  [[SubController2 alloc] init];
    vc.view.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    vc.view.backgroundColor = [UIColor lightGrayColor];
   
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)btn2Action:(id)sender {
    
}

- (void)notificate:(NSNotification *)noti {
    NSLog(@"receive notification1");
}



@end
