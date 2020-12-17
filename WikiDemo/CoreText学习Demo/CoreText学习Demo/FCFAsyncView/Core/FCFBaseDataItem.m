//
//  FCFBaseDataItem.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/17.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "FCFBaseDataItem.h"
#import <UIKit/UIKit.h>

@implementation FCFBaseDataItem

- (NSMutableArray<NSValue *> *)clickableFrames {
    if (_clickableFrames == nil) {
        _clickableFrames = [NSMutableArray array];
    }
    return _clickableFrames;
}

- (void)addFrame:(CGRect)frame {
    [self.clickableFrames addObject:[NSValue valueWithCGRect:frame]];
}

- (BOOL)containsPoint:(CGPoint)point {
    for (NSValue *frameValue in self.clickableFrames) {
        if (CGRectContainsPoint(frameValue.CGRectValue, point)) {
            return YES;
        }
    }
    return false;
}
@end
