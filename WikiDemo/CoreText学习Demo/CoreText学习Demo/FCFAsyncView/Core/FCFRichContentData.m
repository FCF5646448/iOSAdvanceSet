//
//  FCFRichContentData.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/17.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "FCFRichContentData.h"
#import "NSMutableAttributedString+SetAttribute.h"
#import "FCFTextItem.h"
#import "FCFAttachmentItem.h"
#import "FCFLinkItem.h"
#import "FCFTrunContentItem.h"

NSString * const FCFExtraDataAttributeName = @"FCFExtraDataAttributeName";
NSString * const FCFExtraDataAttributeTypeKey = @"FCFExtraDataAttributeTypeKey";
NSString * const FCFExtraDataAttributeDataKey = @"FCFExtraDataAttributeDataKey";
NSString * const FCFRunMetaData = @"FCFRunMetaData";

typedef NS_ENUM(NSUInteger, FCFDataType) {
    FCFDataTypeImage,
    FCFDataTypeView,
    FCFDataTypeText,
    FCFDataTypeLink,
};


@interface FCFRichContentData()
@property (nonatomic, strong) NSMutableAttributedString *attributeString;
@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, strong) NSMutableArray<FCFLinkItem *> *links;
@property (nonatomic, strong) NSMutableArray<FCFTrunContentItem *> *trun;

@end

@implementation FCFRichContentData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _textColor = [UIColor blackColor];
        _font = [UIFont systemFontOfSize:14];
        _lineBreakMode = kCTLineBreakByTruncatingTail;
    }
    return self;
}

- (void)dealloc
{
    if (_drawMode == FCFDrawModeLines) {
        for (FCFCTLine *line in _drawLines) {
            if (line.ctLine != nil) {
                CFRelease(line.ctLine);
            }
        }
    }else{
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
    }
}

#pragma MARK: - Setter 需要特殊处理的
- (void)setText:(NSString *)text {
    _text = text;
    [self.attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:_text attributes:nil]];
    [self.attributeString fcf_setFont:_font];
    [self.attributeString fcf_setTextColor:_textColor];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self.attributeString fcf_setTextColor:_textColor];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self.attributeString fcf_setFont:_font];
    [self updateAttachments];
}





#pragma MARK: - 添加数据
- (void)addString:(NSString *)string attribute:(NSDictionary *)attribute clickActionHandler:(ClickActionHandler)clickActionHandler {
    FCFTextItem *textItem = [FCFTextItem new];
    textItem.content = string;
    NSAttributedString * textAttri = [[NSAttributedString alloc] initWithString:textItem.content attributes:attribute];
    [self.attributeString appendAttributedString:textAttri];
    
}
//
- (void)addLink:(NSString *)link clickActionHandler:(ClickActionHandler)clickActionHandler {
    FCFLinkItem *linkItem = [FCFLinkItem new];
    linkItem.content = link;
    linkItem.clickActionHandler = clickActionHandler;
    [self.links addObject:linkItem];
    [self.attributeString appendAttributedString:[self linkAttributeStringWithLinkItem:linkItem]];
}
//
- (void)addImage:(UIImage *)image size:(CGSize)size clickActionHandler:(ClickActionHandler)clickActionHandler {
    FCFAttachmentItem *imageItem = [FCFAttachmentItem new];
    imageItem.ascent = CTFontGetAscent((CTFontRef)self.font);
    imageItem.descent = CTFontGetDescent((CTFontRef)self.font);
    imageItem.attachment = image;
    imageItem.type = FCFAttachmentTypeImage;
    imageItem.size = size;
    imageItem.clickActionHandler = clickActionHandler;
    [self.attachments addObject:imageItem];
    
    NSAttributedString *imageAttributeString = [self attachmentAttributeStringWithAttachmentItem:imageItem size:size];
    [self.attributeString appendAttributedString:imageAttributeString];
}
//
- (void)addView:(UIView *)view size:(CGSize)size clickActionHandler:(ClickActionHandler)clickActionHandler {
    [self addView:view size:size align:FCFAttachmentAlignTypeBottom clickActionHandler:clickActionHandler];
}
//
- (void)addView:(UIView *)view size:(CGSize)size align:(FCFAttachmentAlignType)align clickActionHandler:(ClickActionHandler)clickActionHandler {
    FCFAttachmentItem *viewItem = [FCFAttachmentItem new];
    viewItem.ascent = CTFontGetAscent((CTFontRef)self.font);
    viewItem.descent = CTFontGetDescent((CTFontRef)self.font);
    viewItem.align = align;
    viewItem.attachment = view;
    viewItem.type = FCFAttachmentTypeView;
    viewItem.size = size;
    viewItem.clickActionHandler = clickActionHandler;
    [self.attachments addObject:viewItem];
    NSAttributedString *viewAttributeString = [self attachmentAttributeStringWithAttachmentItem:viewItem size:size];
    [self.attributeString appendAttributedString:viewAttributeString];
}


// 生成UIView需要使用的数据 bounds绘制区域
- (void)composeDataToDrawWithBounds:(CGRect)bounds {
    _ctFrame = [self composeCTFrameWithAttributeString:self.attributeStringToDraw frame:bounds];
    [self calculateContentPositionWithBounds:bounds];
    [self calculateTruncatedLinesWithBounds:bounds];
    
}

// 获取view点击位置的数据
- (FCFBaseDataItem *)itemAtPoint:(CGPoint)point {
    for (FCFBaseDataItem *item in self.trun) {
        if ([item containsPoint:point]) {
            return item;
        }
    }
    
    for (FCFBaseDataItem *item in self.links) {
        if ([item containsPoint:point]) {
            return item;
        }
    }
    
    for (FCFBaseDataItem *item in self.attachments) {
        if ([item containsPoint:point]) {
            return item;
        }
    }
    return nil;
}

// 获取CTFrame对应的AttributedString数据
- (NSAttributedString *)attributeStringToDraw {
    [self setStyleToAttributeString:self.attributeString];
    return self.attributeString;
}

- (CTFrameRef)drawFrame {
    return self.ctFrame;
}


// 生成CTFrame
- (CTFrameRef)composeCTFrameWithAttributeString:(NSAttributedString *)attributeString frame:(CGRect)frame {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, frame.size.width, frame.size.height));
    
    CTFramesetterRef ctFrameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) attributeString);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFrameSetter, CFRangeMake(0, attributeString.length), path, NULL);
    
    CFRelease(ctFrameSetter);
    CFRelease(ctFrame);
    
    return ctFrame;
}

// 计算和跳转图片或view的位置
- (void)calculateContentPositionWithBounds:(CGRect)bounds {
    
    NSUInteger imageIndex = 0;
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    
    CGPoint lineOrigins[lines.count];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    for (int i = 0; i < lines.count; i++) {
        CTLineRef line = (__bridge CTLineRef)(lines[i]);
        
        NSArray *runs = (NSArray *)CTLineGetGlyphRuns(line);
        
        for (int j = 0; j < runs.count; j++) {
            CTRunRef run = (__bridge CTRunRef)(runs[j]);
            
            NSDictionary *attributes = (NSDictionary *)CTRunGetAttributes(run);
            if (!attributes) {
                continue;
            }
            
            // 获取附件的数据——>设置连接、图片等元素的点击效果的位置
            NSDictionary *extraData = (NSDictionary *)[attributes valueForKey:FCFExtraDataAttributeName];
            if (extraData) {
                NSInteger type = [[extraData valueForKey:FCFExtraDataAttributeTypeKey] integerValue];
                FCFBaseDataItem *data = (FCFBaseDataItem *)[extraData valueForKey:FCFExtraDataAttributeDataKey];
                NSLog(@"run = (%@-%@) type = %@ data = %@", @(i), @(j), @(type), data);
                
                // 获取CTRun的信息
                CGFloat ascent;
                CGFloat desent;
                // 直接从元数据获取到图片的宽度和高度信息
                CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &desent, NULL);
                CGFloat height = ascent + desent;
                
                //
                CGFloat xOffset = lineOrigins[i].x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                CGFloat yOffset = bounds.size.height - lineOrigins[i].y - ascent;
                
                if ([data isKindOfClass:[FCFBaseDataItem class]]) {
                    //
                    CGRect uiKitClickableFrame = CGRectMake(xOffset, yOffset, width, height);
                    [data addFrame:uiKitClickableFrame];
                }
            }
            
            
            // 从属性中获取到创建属性字符串使用CFAttributedStringSetAttribute设置的delegate值
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (!delegate) {
                continue;
            }
            
            // CTRunDelegateGetRefCon方法从delegate中获取使用CTRunDelegateCreate初始时候设置的元数据
            NSDictionary *metaData = (NSDictionary *)CTRunDelegateGetRefCon(delegate);
            if (!metaData) {
                continue;
            }
            
            // 找到代理则开始计算图片位置信息
            CGFloat ascent;
            CGFloat descent;
            // 可以直接从metaData获取到图片的宽度和高度信息
            CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            CGFloat height = ascent + descent;
            
            // CTLineGetOffsetForStringIndex获取CTRun的起始位置
            CGFloat xOffset = lineOrigins[i].x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            CGFloat yOffset = lineOrigins[i].y;
            
            //
            if (imageIndex < self.attachments.count) {
                FCFAttachmentItem *imageItem = self.attachments[imageIndex];
                if (imageItem.type == FCFAttachmentTypeView) {
                    yOffset = bounds.size.height - lineOrigins[i].y - ascent;
                }else if (imageItem.type == FCFAttachmentTypeImage) {
                    yOffset = yOffset - descent;
                }
                imageItem.frame = CGRectMake(xOffset, yOffset, width, height);
                
                imageIndex ++;
            }
            
            
        }
    }
    
}

- (void)calculateTruncatedLinesWithBounds:(CGRect)bounds {
    //清除旧数据
    [self.trun removeAllObjects];
    
    // 获取最终需要绘制的文本行数
    CFIndex numberOfLinesToDraw;
    if (_numOfLines <= 0) {
        numberOfLinesToDraw = _numOfLines;
    }else{
        numberOfLinesToDraw = MIN(CFArrayGetCount(CTFrameGetLines(self.ctFrame)), _numOfLines);
    }
    if (numberOfLinesToDraw <= 0) {
        self.drawMode = FCFDrawModeFrame;
    }else{
        self.drawMode = FCFDrawModeLines;
        NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
        
        CGPoint lineOrigins[numberOfLinesToDraw];
        CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, numberOfLinesToDraw), lineOrigins);
        
        for (int lineIndex = 0; lineIndex < numberOfLinesToDraw ; lineIndex++) {
            CTLineRef line = (__bridge CTLineRef)(lines[lineIndex]);
            CFRange range = CTLineGetStringRange(line);
            // 判断最后一行是否需要显示【截断标识字符串(...)】
            if (lineIndex == numberOfLinesToDraw - 1 && range.location + range.length < [self attributeStringToDraw].length) {
                
                // 创建【截断标识字符串(...)】
                NSMutableAttributedString *tokenString = nil;
                if (_trunToken) {
                    tokenString = _trunToken;
                }else{
                    NSUInteger trunAttriPosition = range.location + range.length - 1;
                    NSDictionary *attributes = [[self attributeStringToDraw] attributesAtIndex:trunAttriPosition effectiveRange:NULL];
                    
                    //只要用到字体大小和颜色的属性，这里如果使用kCTParagraphStyleAttributeName属性在使用boundingRectWithSize方法计算大小的步骤会崩溃
                    NSDictionary *tokenAttributes = @{NSForegroundColorAttributeName: (attributes[NSForegroundColorAttributeName] ? attributes[NSForegroundColorAttributeName] : [UIColor blackColor]), NSFontAttributeName: (attributes[NSFontAttributeName] ? attributes[NSFontAttributeName] : [UIFont systemFontOfSize:14]) };
                    tokenString = [[NSMutableAttributedString alloc] initWithString:@"\u2026" attributes:tokenAttributes];
                }
                
                // 计算【截断标识字符串(...)】的长度
                CGSize tokenSize = [tokenString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:NULL].size;
                CGFloat tokenWidth = tokenSize.width;
                CTLineRef trunTokenLine = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenString);
                
                // 根据【截断标识字符串(...)】的长度，计算【需要截断字符串】的最后一个字符的位置，把该位置之后的字符从【需要截断字符串】中移除，留出【截断标识字符串(...)】的位置
                CFIndex trunEndIndex = CTLineGetStringIndexForPosition(line, CGPointMake(bounds.size.width - tokenWidth, 0));
                CGFloat length = range.location + range.length - trunEndIndex;
                
                // 把【截断标识字符串(...)】添加到【需要截断字符串】后面
                NSMutableAttributedString *trunString = [[[self attributeStringToDraw] attributedSubstringFromRange:NSMakeRange(range.location, range.length)] mutableCopy];
                if (length < trunString.length) {
                    [trunString deleteCharactersInRange:NSMakeRange(trunString.length - length, length)];
                    [trunString appendAttributedString:tokenString];
                }
                
                // 使用`CTLineCreateTruncatedLine`方法创建含有【截断标识字符串(...)】的`CTLine`对象
                CTLineRef trunline = CTLineCreateWithAttributedString((CFAttributedStringRef)trunString);
                CTLineTruncationType trunType = kCTLineTruncationEnd;
                CTLineRef lastLine = CTLineCreateTruncatedLine(trunline, bounds.size.width, trunType, trunTokenLine);
                
                // 添加truncation的位置信息
                NSArray *runs = (NSArray *)CTLineGetGlyphRuns(line);
                if (runs.count > 0 && self.trunActionHandler) {
                    CTRunRef run = (__bridge CTRunRef)runs.lastObject;
                    
                    CGFloat ascent;
                    CGFloat descent;
                    CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
                    CGFloat height = ascent + descent;
                    
                    FCFTrunContentItem * trunItem = [FCFTrunContentItem new];
                    CGRect trunFrame = CGRectMake(width - tokenWidth, bounds.size.width - lineOrigins[lineIndex].y - height, tokenSize.width, tokenSize.height);
                    
                    [trunItem addFrame:trunFrame];
                    trunItem.clickActionHandler = self.trunActionHandler;
                    [self.trun addObject:trunItem];
                }
                
                FCFCTLine *ctLine = [FCFCTLine new];
                ctLine.ctLine = lastLine;
                ctLine.position = CGPointMake(lineOrigins[lineIndex].x, lineOrigins[lineIndex].y);
                [self.drawLines addObject:ctLine];
                
                CFRelease(trunTokenLine);
                CFRelease(trunline);
                
            }else{
                FCFCTLine *ctLine = [FCFCTLine new];
                ctLine.ctLine = line;
                ctLine.position = CGPointMake(lineOrigins[lineIndex].x, lineOrigins[lineIndex].y);
                [self.drawLines addObject:ctLine];
            }
            
        }
    }
    
}

- (void)setStyleToAttributeString:(NSMutableAttributedString *)attributeString {
    CTParagraphStyleSetting setting[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(self.textAlignment), &_textAlignment},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(self.lineSpacing), &_lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(self.lineSpacing), &_lineSpacing},
        {kCTParagraphStyleSpecifierParagraphSpacing, sizeof(self.paragraphSpacing), &_paragraphSpacing}
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(setting, sizeof(setting)/sizeof(setting[0]));
    [attributeString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)paragraphStyle  range:NSMakeRange(0, [attributeString length])];
    CFRelease(paragraphStyle);
}


// 生成linkAttrinuteString 自定义部分属性
- (NSAttributedString *)linkAttributeStringWithLinkItem:(FCFLinkItem *)linkItem {
    NSMutableAttributedString * linkAttributeString = [[NSMutableAttributedString alloc] initWithString:linkItem.content attributes:[self linkTextAttribute]];
    NSDictionary *extraData = @{FCFExtraDataAttributeTypeKey: @(FCFDataTypeLink), FCFExtraDataAttributeDataKey: linkItem};
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef) linkAttributeString, CFRangeMake(0, linkItem.content.length), (CFStringRef)FCFExtraDataAttributeName, (__bridge CFTypeRef)(extraData));
    return linkAttributeString;
}

// 生成图片或view的AttributeString
- (NSAttributedString *)attachmentAttributeStringWithAttachmentItem:(FCFAttachmentItem *)attachmentItem size:(CGSize)size {
    //定义callback
    CTRunDelegateCallbacks callback;
    memset(&callback, 0, sizeof(CTRunDelegateCallbacks));
    callback.getAscent = getAscent;
    callback.getDescent = getDescent;
    callback.getWidth = getWidth;
    
    //使用元数据创建CTRunDelegateRef
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callback, (__bridge void * _Nullable)(attachmentItem));
    
    //设置图片属性字符串
    unichar objecttReplacementChar = 0xFFFC;
    NSMutableAttributedString * imagePlaceHoldAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithCharacters:&objecttReplacementChar length:1] attributes:[self defaultTextAttributes]];
    
    //设置RunDelegate代理
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)imagePlaceHoldAttributeString, CFRangeMake(0, 1), kCTRunDelegateAttributeName, runDelegate);
    
    //设置附加数据， 设置点击效果
    NSDictionary * extraData = @{FCFExtraDataAttributeTypeKey: attachmentItem.type == FCFAttachmentTypeImage ? @(FCFDataTypeImage):@(FCFDataTypeView),
                                 FCFExtraDataAttributeDataKey: attachmentItem};
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)imagePlaceHoldAttributeString, CFRangeMake(0, 1), (CFStringRef)FCFExtraDataAttributeName , (CFTypeRef)(extraData));
    
    CFRelease(runDelegate);
    
    return imagePlaceHoldAttributeString;
}



- (NSDictionary *)defaultTextAttributes {
    return @{NSFontAttributeName: [UIFont systemFontOfSize:18],
             NSForegroundColorAttributeName: [UIColor blackColor]};
}

- (NSDictionary *)linkTextAttribute {
    return @{NSFontAttributeName: [UIFont systemFontOfSize:18],
             NSForegroundColorAttributeName: [UIColor blueColor],
             NSUnderlineStyleAttributeName: @1,
             NSUnderlineColorAttributeName: [UIColor blueColor]};
}


- (void)updateAttachments {
    
}


#pragma MARK: CTRunDelegateCallbacks 回调方法
static CGFloat getAscent(void *ref) {
    FCFAttachmentItem *attentmentItem = (__bridge FCFAttachmentItem *)ref;
    if (attentmentItem.align == FCFAttachmentAlignTypeTop) {
        return attentmentItem.ascent;
    }else if (attentmentItem.align == FCFAttachmentAlignTypeBottom) {
        return attentmentItem.size.height - attentmentItem.descent;
    }else if (attentmentItem.align == FCFAttachmentAlignTypeCenter) {
        return attentmentItem.ascent - ((attentmentItem.descent + attentmentItem.ascent) - attentmentItem.size.height) / 2;
    }
    return attentmentItem.size.height;
}


static CGFloat getDescent(void *ref) {
    FCFAttachmentItem *attentmentItem = (__bridge FCFAttachmentItem *)ref;
    if (attentmentItem.align == FCFAttachmentAlignTypeTop) {
        return attentmentItem.size.height - attentmentItem.ascent;
    }else if (attentmentItem.align == FCFAttachmentAlignTypeBottom) {
        return attentmentItem.descent;
    }else if (attentmentItem.align == FCFAttachmentAlignTypeCenter) {
        return attentmentItem.size.height - attentmentItem.ascent + ((attentmentItem.descent + attentmentItem.ascent) - attentmentItem.size.height)/2;
    }
    return 0;
}

static CGFloat getWidth(void *ref) {
    FCFAttachmentItem *attentmentItem = (__bridge FCFAttachmentItem *)ref;
    return attentmentItem.size.width;
}




@end
