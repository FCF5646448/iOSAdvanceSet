//
//  FCFAttachmentItem.h
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/17.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "FCFBaseDataItem.h"
#import <UIKit/UIKit.h>

// 附件类型
typedef NS_ENUM(NSUInteger, FCFAttachmentType) {
    FCFAttachmentTypeImage,
    FCFAttachmentTypeView,
};

// 附件的位置
typedef NS_ENUM(NSUInteger, FCFAttachmentAlignType) {
    FCFAttachmentAlignTypeTop,
    FCFAttachmentAlignTypeCenter,
    FCFAttachmentAlignTypeBottom,
};

NS_ASSUME_NONNULL_BEGIN

/// 附件类，表示添加的是View或者Image

@interface FCFAttachmentItem : FCFBaseDataItem

@property (nonatomic, assign) FCFAttachmentType type;
@property (nonatomic, assign) FCFAttachmentAlignType align;
//
@property (nonatomic, strong) id attachment;
@property (nonatomic, assign) CGRect frame;
// CoreText中文本的 上行行高
@property (nonatomic, assign) CGFloat ascent;
// CoreText中文本的 下行行高
@property (nonatomic, assign) CGFloat descent;
// 附件内容size
@property (nonatomic, assign) CGSize size;

- (UIImage *)image;
- (UIView *)view;

@end

NS_ASSUME_NONNULL_END
