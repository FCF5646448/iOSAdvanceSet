//
//  Person.m
//  KVCDemo
//
//  Created by 冯才凡 on 2020/10/28.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "Person.h"

@implementation Cat

@end

@implementation Person

//- (void)setAge:(int)age {
//    _age = age;
//    NSLog(@"Person setAge: %d", age);
//}

- (void)_setAge:(int)age {
//    _age = age;
    NSLog(@"Person _setAge: %d", age);
}

+ (BOOL)accessInstanceVariablesDirectly {
    return true;
}


@end
