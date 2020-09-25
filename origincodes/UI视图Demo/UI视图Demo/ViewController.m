//
//  ViewController.m
//  UI视图Demo
//
//  Created by 冯才凡 on 2019/5/10.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "ReuseTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * img = [UIImage imageNamed:@""];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:img forKey:@"img"];
    

}

- (IBAction)tbAction:(id)sender {
    ReuseTableViewController * vc = [[ReuseTableViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}




@end
