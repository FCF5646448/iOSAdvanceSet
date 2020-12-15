//
//  ImageItem.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/15.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ImageItem.h"

@implementation ImageItem

- (instancetype)initWithImageName:(NSString *)name frame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.imgName = name;
        self.frame = frame;
    }
    return self;
}

@end
