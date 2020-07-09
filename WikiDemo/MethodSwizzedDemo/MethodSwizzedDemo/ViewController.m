//
//  ViewController.m
//  MethodSwizzedDemo
//
//  Created by 冯才凡 on 2020/5/28.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ViewController.h"

typedef void(^TestBlock)(void);

@interface ViewController ()
@property (nonatomic, copy) TestBlock block;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSObject* obj = [[NSObject alloc]init];
    [obj performSelector:@selector(crash) withObject:nil afterDelay:0];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    [dic setObject:nil forKey:@"1"]; //crash
//    [dic setValue:nil forKey:@"1"]; // not crash
//    [dic setObject:@"1" forKey:nil]; //crash
//    [dic setValue:@"1" forKey:nil]; //crash
    
    NSNull *nullStr = [[NSNull alloc] init];
//    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:nullStr forKey:@"key"]; //not crash
    NSNumber* number = [dic valueForKey:@"key"]; //crash
    
    
    NSMutableArray * arr = [NSMutableArray array];
    _block = ^{
        arr = [NSMutableArray array];
    };
    
    _block();
    
}




- (void)test {
    printf("ViewController test");
}

@end
