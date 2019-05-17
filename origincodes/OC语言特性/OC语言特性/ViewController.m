//
//  ViewController.m
//  OC语言特性
//
//  Created by 冯才凡 on 2019/5/14.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CFGetRetainCount((__bridge CFTypeRef)(obj))
    //(long)[[obj valueForKey:@"retainCount"] integerValue]
    
    // ARC 下 ，默认是会给这个栈block进行copy操作的。
    NSObject * obj = [[NSObject alloc] init];
    NSLog(@"1:%ld",(long)[[obj valueForKey:@"retainCount"] integerValue]);
    void (^foo)(void) = ^ {
        NSLog(@"2:%ld",(long)[[obj valueForKey:@"retainCount"] integerValue]);
    };
    NSLog(@"3:%ld",(long)[[obj valueForKey:@"retainCount"] integerValue]);
    foo();
    NSLog(@"4:%ld",(long)[[obj valueForKey:@"retainCount"] integerValue]);
}


@end
