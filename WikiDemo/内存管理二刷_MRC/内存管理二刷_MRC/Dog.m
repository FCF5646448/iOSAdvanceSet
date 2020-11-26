//
//  Dog.m
//  内存管理二刷_MRC
//
//  Created by 冯才凡 on 2020/11/26.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "Dog.h"

@implementation Dog
- (void)run {
    NSLog(@"%s", __func__);
}

- (void)dealloc
{
    [super dealloc];
    NSLog(@"%s", __func__);
}
@end
