//
//  ImageTextData.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/15.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ImageTextData.h"

@implementation ImageTextData

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)dealloc
{
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
    }
}

@end
