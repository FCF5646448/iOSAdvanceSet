//
//  main.m
//  内存管理二刷_MRC
//
//  Created by 冯才凡 on 2020/11/26.
//  Copyright © 2020 冯才凡. All rights reserved.
//

// 已经关闭了自动内存管理
#import <Foundation/Foundation.h>
#import "Person.h"
#import "Dog.h"

void test1();
void test2();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        test1();
        test2();
    }
    NSLog(@"4");
    return 0;
}

void test1() {
    
    //        Person *person = [Person new];
    //        NSLog(@"%zd", person.retainCount);
    //        // 手动销毁
    //        [person release];
    
    // autorelease不会立马调用。通常来说，是在当前runloop对AutoreleasePool执行最近一次pop的时候释放。
    Person *person2 = [[Person new] autorelease];
    NSLog(@"1");
    {
        Person *person3 = [[Person new] autorelease];
        NSLog(@"2");
    }
    NSLog(@"3");
}// person2 和 person3 都是在这个位置释放

void test2() {
    Dog * dog1 = [[Dog alloc] init];
    Dog * dog2 = [[Dog alloc] init];
    
    Person * person = [[Person alloc] init];
    
    [person setDog:dog1];
    [person setDog:dog2];

    [[person dog] run];
    
    [dog1 release];
    [dog2 release];
    
    [[person dog] run];
    
    [person release];
}
