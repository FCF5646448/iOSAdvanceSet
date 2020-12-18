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
@property (nonatomic, strong) NSMutableArray<FCFCTLine *> *drawLines;
@property (nonatomic, assign) CTFrameRef drawFrame;
// 绘制模式
@property (nonatomic, assign) FCFDrawMode drawMode;
// 行数
@property (nonatomic, assign) NSInteger numOfLines;
// 截断的标识字符串, 默认是 "__"
@property (nonatomic, strong) NSMutableAttributedString *trunToken;
// 截断标识符点击事件
@property (nonatomic, copy) ClickActionHandler trunActionHandler;
// 文本内容
@property (nonatomic, copy) NSString *text;
// 字体颜色
@property (nonatomic, strong) UIColor *textColor;
// 字体
@property (nonatomic, strong) UIFont *font;
// 阴影颜色
@property (nonatomic, strong) UIColor *shadowColor;
// 阴影偏移位置
@property (nonatomic, assign) CGSize shadowOffSet;
// 阴影透明度
@property (nonatomic, assign) CGFloat shadowAlpha;
// 换行模式
@property (nonatomic, assign) CTLineBreakMode lineBreakMode;
// 行间距
@property (nonatomic, assign) CGFloat lineSpacing;
// 段落距离
@property (nonatomic, assign) CGFloat paragraphSpacing;
// 文字排版样式
@property (nonatomic, assign) CTTextAlignment textAlignment;


//
- (void)addString:(NSString *)string attribute:(NSDictionary *)attribute clickActionHandler:(ClickActionHandler)clickActionHandler;
//
- (void)addLink:(NSString *)link clickActionHandler:(ClickActionHandler)clickActionHandler;
//
- (void)addImage:(UIImage *)image size:(CGSize)size clickActionHandler:(ClickActionHandler)clickActionHandler;
//
- (void)addView:(UIView *)view size:(CGSize)size clickActionHandler:(ClickActionHandler)clickActionHandler;
//
- (void)addView:(UIView *)view size:(CGSize)size align:(FCFAttachmentAlignType)align clickActionHandler:(ClickActionHandler)clickActionHandler;


// 生成UIView需要使用的数据 bounds绘制区域
- (void)composeDataToDrawWithBounds:(CGRect)bounds;
// 获取view点击位置的数据
- (FCFBaseDataItem *)itemAtPoint:(CGPoint)point;
// 获取CTFrame对应的AttributedString数据
- (NSAttributedString *)attributeStringToDraw;




@end

NS_ASSUME_NONNULL_END
