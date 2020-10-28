//
//  main.m
//  KVCDemo
//
//  Created by 冯才凡 on 2020/10/28.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "Observer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Observer * observer = [Observer new];
        Person * person = [Person new];
        person.cat = [Cat new];
        
        // 添加KVO监听
//        [person addObserver:observer forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        // 通过KVC触发
        [person setValue:@10 forKey:@"age"];
        [person setValue:@100 forKeyPath:@"cat.weight"];
        
//        NSLog(@"age: %@", [person valueForKey:@"age"]);
//        NSLog(@"cat w: %@", [person valueForKeyPath:@"cat.weight"]);
        
        //移除
//        [person removeObserver:observer forKeyPath:@"age"];
    }
    return 0;
}
