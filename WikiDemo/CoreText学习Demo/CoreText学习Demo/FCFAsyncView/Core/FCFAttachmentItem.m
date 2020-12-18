//
//  FCFAttachmentItem.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/17.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "FCFAttachmentItem.h"

@implementation FCFAttachmentItem

- (UIImage *)image {
    if ([_attachment isKindOfClass:[UIImage class]]) {
        return _attachment;
    }
    return nil;
}

- (UIView *)view {
    if ([_attachment isKindOfClass:[UIView class]]) {
        return _attachment;
    }
    return nil;
}
@end
