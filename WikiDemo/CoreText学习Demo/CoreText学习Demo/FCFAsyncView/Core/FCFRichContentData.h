//
//  FCFRichContentData.h
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/17.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "FCFAttachmentItem.h"
#import "FCFCTLine.h"

typedef NS_ENUM(NSUInteger, FCFDrawMode) {
    FCFDrawModeLines,
    FCFDrawModeFrame,
};

NS_ASSUME_NONNULL_BEGIN

@interface FCFRichContentData : NSObject

// 外挂数据
@property (nonatomic, strong) NSMutableArray<FCFAttachmentItem *> *attachments;
//绘制的CTLine数据
@property (nonatomic, strong) NSMutableArray<FCFCTLine *> * DrawLines;
@property (nonatomic, assign) CTFrameRef DrawFrame;
// 绘制模式
@property (nonatomic, assign) FCFDrawMode drawMode;
// 行数
@property (nonatomic, assign) NSInteger numOfLines;
// 


@end

NS_ASSUME_NONNULL_END
