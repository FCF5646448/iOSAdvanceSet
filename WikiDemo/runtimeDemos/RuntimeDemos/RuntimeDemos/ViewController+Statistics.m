//
//  ViewController+Statistics.m
//  RuntimeDemos
//
//  Created by 冯才凡 on 2019/1/10.
//  Copyright © 2019年 冯才凡. All rights reserved.
//

#import "ViewController+Statistics.h"
#import <objc/runtime.h>

@implementation ViewController (Statistics)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
        Method newMethod = class_getInstanceMethod([self class], @selector(viewDidLoadStatistic));
        //class_addMethod 检查方法是否存在
        if (!class_addMethod([self class], @selector(viewDidLoadStatistic), method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            method_exchangeImplementations(originMethod, newMethod);
        }
    });
}

- (void)viewDidLoadStatistic {
    NSString * str = NSStringFromClass([self class]);
    NSLog(@"统计：%@",str);
    [self viewDidLoadStatistic];
}
@end
