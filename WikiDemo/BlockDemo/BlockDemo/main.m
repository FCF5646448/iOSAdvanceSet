//
//  main.m
//  BlockDemo
//
//  Created by 冯才凡 on 2020/10/28.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //
        ^{
            NSLog(@"这是一个block");
        };
        
        void (^block)() = ^{
            NSLog(@"这又是一个block");
        };
        
        block();
        
        void (^block2)(int, NSString *) = ^(int a, NSString * b){
            NSLog(@"这是一个带参数的block");
            NSLog(@"%d", a);
            NSLog(@"%@", b);
        };
        block2(1,@"b");
        
    }
    return 0;
}
