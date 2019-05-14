//
//  MObject.m
//  OC语言特性
//
//  Created by 冯才凡 on 2019/5/14.
//  Copyright © 2019 冯才凡. All rights reserved.
//

#import "MObject.h"

@implementation MObject
- (instancetype)init
{
    self = [super init];
    if (self) {
        _value = 0;
    }
    return self;
}

-(void)increase {
    _value += 1;
}


-(void)setValue:(int)value {
    NSLog(@"%d",value);
}

@end

