//
//  ViewController.m
//  内存管理二刷Demo
//
//  Created by 冯才凡 on 2020/11/26.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __strong Person *person1;   // 通常默认情况下，是__strong修饰，可能会被省略。
    __weak Person *person2;     // 对象被清空后，指针会自动置为nil
    __unsafe_unretained Person *person3;    // 对象被情况后，指针不会自动置为nil，会产生野指针。所以这个基本已经不再使用
    
    NSLog(@"123");
    {
        Person *person = [[Person alloc] init];
        person1 = person;
    } // 如果不把person赋值给任何指针，则person在这里就会销毁；如果把person赋值给__weak和__unsafe_unretained修饰的指针变量，那也是在这里就会销毁。如果把它赋值给__strong修饰的指针变量，那么它将在当前函数结束之后释放。
    
    NSLog(@"456");
    
}


@end
