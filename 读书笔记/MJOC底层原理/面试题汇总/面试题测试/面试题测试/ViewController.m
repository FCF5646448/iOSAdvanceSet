//
//  ViewController.m
//  面试题测试
//
//  Created by 冯才凡 on 2019/11/26.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [Student new];
//
//    BOOL res1 = [[NSObject class] isKindOfClass:[NSObject class]];
//    BOOL res2 = [[NSObject class] isMemberOfClass:[NSObject class]];
//    BOOL res3 = [[Person class] isKindOfClass:[Person class]];
//    BOOL res4 = [[Person class] isMemberOfClass:[Person class]];
//
//    NSLog(@"%d %d %d %d",res1,res2,res3,res4);
    
//    id cls = [Person class];
//    void * obj = &cls;
//    [(__bridge id)obj print];
    
    Class objc = [[NSObject class] class];
    NSLog(@"%@",objc);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 题解https://blog.csdn.net/M316625387/article/details/83818758
    NSThread * thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
    }];
    [thread start];
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:YES];
    
}

- (void)test {
    NSLog(@"2");
}



@end
