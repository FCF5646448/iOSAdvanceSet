//
//  FCFDrawView.h
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/18.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "FCFBaseDataItem.h"
#import "FCFAttachmentItem.h"


NS_ASSUME_NONNULL_BEGIN

@interface FCFDrawView : UIView

@property (nonatomic, assign) NSInteger numOfLines;
@property (nonatomic, strong) NSAttributedString *trunToken;
@property (nonatomic, copy) ClickActionHandler trunActionHandler;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffSet;
@property (nonatomic, assign) CGFloat shadowAlpha;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat paragrapSpacing;
@property (nonatomic, assign) CTTextAlignment textAlignment;

- (void)addString:(NSString *)string attribute:(NSDictionary *)attribute clickActionHandler:(ClickActionHandler)clickActionHandler;

- (void)addLink:(NSString *)link clickActionHandler:(ClickActionHandler)clickActionHandler;

- (void)addImage:(UIImage *)image size:(CGSize)size clickActionHandler:(ClickActionHandler)clickActionHandler;

- (void)addView:(UIView *)view size:(CGSize)size clickActionHandler:(ClickActionHandler)clickActionHandler;

- (void)addView:(UIView *)view size:(CGSize)size align:(FCFAttachmentAlignType)align clickActionHandler:(ClickActionHandler)clickActionHandler;

@end

NS_ASSUME_NONNULL_END
