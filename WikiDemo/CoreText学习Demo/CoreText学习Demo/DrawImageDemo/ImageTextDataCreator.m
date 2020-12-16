//
//  ImageTextDataCreator.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/15.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageTextDataCreator.h"
#import "ImageItem.h"


@interface ImageTextDataCreator()
@property (nonatomic, strong) ImageTextData * imgText;
@end

@implementation ImageTextDataCreator

- (ImageTextData *)imagetextDataWithhFrame:(CGRect)frame {
    if (!_imgText) {
        _imgText = [ImageTextData new];
        _imgText.attributeString = [self attributeStringForDraw];
        //计算CTFrame，然后根据CTFrame计算图片所在位置
        CTFrameRef ctFrame = [self ctFrameWithAttributeString:_imgText.attributeString frame:frame];
        _imgText.ctFrame = ctFrame;
        // 设置图片数据
        [_imgText.images addObject:[[ImageItem alloc] initWithImageName:@"tata_popup_img_rise" frame:CGRectZero]];
        // 计算图片位置， 更新_imgText.images
        [self calculateImagePosition];
        
    }
    
    return _imgText;
}


- (NSMutableAttributedString *)attributeStringForDraw {
    NSMutableAttributedString * attri = [NSMutableAttributedString new];
    
    // 添加文字
    [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@"Hello world fcf" attributes:[self defaultTextAttributes]]];
    
//    [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@"HelloWorld" attributes:[self blodHighlightTextAttribute]]];
//
    [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@"www.baidu.com" attributes:[self linktAttribute]]];
    
    // 添加图片
    [attri appendAttributedString:[self imageAttributeString]];
    
    [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@"22 Hello world fcf Hello world fcf Hello world fcf Hello world fcf Hello world fcf22" attributes:[self defaultTextAttributes]]];
    
    return attri;
}

- (CTFrameRef)ctFrameWithAttributeString:(NSAttributedString *)attributestring frame:(CGRect)frame {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, frame.size.width, frame.size.height));
    
    //
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) attributestring);
    CTFrameRef ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributestring.length), path, NULL);
    
    CFRelease(framesetter);
    CFRelease(path);
    
    return ctframe;
}


- (void)calculateImagePosition {
    if (_imgText.images.count < 1) {
        return;
    }
    
    //
    NSArray * lines = (NSArray *)CTFrameGetLines(_imgText.ctFrame);
    //
    CGPoint lineOrigins[lines.count];
    CTFrameGetLineOrigins(_imgText.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    NSInteger index = 0;
    for (int i = 0; i < lines.count; i++) {
        CTLineRef line = (__bridge CTLineRef)(lines[i]);
        
        NSArray * runs = (NSArray *)CTLineGetGlyphRuns(line);
        for (int j = 0; j < runs.count; j++ ) {
            CTRunRef run = (__bridge CTRunRef)(runs[j]);
            NSDictionary * attri = (NSDictionary * )CTRunGetAttributes(run);
            if (!attri) {
                continue;
            }
            
            //从属性中获取RunDelegate
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attri valueForKey:(id)kCTRunDelegateAttributeName];
            if (!delegate) {
                continue;
            }
            
            //从RunDelegate中获取元数据
            NSDictionary *metaData = (NSDictionary *)CTRunDelegateGetRefCon(delegate);
            if (!metaData) {
                continue;
            }
            
            //开始计算图片位置
            CGFloat ascent;
            CGFloat descent;
            // 获取图片的宽度信息
            CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            
            // 获取CTRun的起始位置
            CGFloat xOffSet = lineOrigins[i].x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            CGFloat yOffSet = lineOrigins[i].y;
            
            //
            ImageItem *imgItem = _imgText.images[index];
            imgItem.frame = CGRectMake(xOffSet, yOffSet, width, ascent + descent);
            
            index ++;
            
            if (index >= _imgText.images.count) {
                return;
            }
        }
        
    }
    
}


- (NSAttributedString *)imageAttributeString {
    // 1、创建CTRunDelegateCallBacks
    CTRunDelegateCallbacks callback;
    memset(&callback, 0, sizeof(CTRunDelegateCallbacks)); //分配内存
    callback.getAscent = getAscent;
    callback.getDescent = getDescent;
    callback.getWidth = getWidth;
    
    // 2、创建CTRunDelegateRef
    NSDictionary * metaData = @{@"width": @120, @"height": @140};
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callback, (__bridge_retained void *)metaData);
    
    // 3、设置占位使用的图片属性字符串
    unichar objecReplacementChar = 0xFFFC;
    NSMutableAttributedString * imaPlaceHolderAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithCharacters:&objecReplacementChar length:1] attributes:[self defaultTextAttributes]];
    
    // 4、设置RunDelegate代理
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)imaPlaceHolderAttributeString, CFRangeMake(0, 1), kCTRunDelegateAttributeName, runDelegate);
    
    CFRelease(runDelegate);
    return imaPlaceHolderAttributeString;
}

- (NSDictionary *)defaultTextAttributes {
    NSDictionary * attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName: [UIColor cyanColor]};
    return attributes;
}

- (NSDictionary *)blodHighlightTextAttribute {
    NSDictionary * attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:24], NSForegroundColorAttributeName: [UIColor redColor]};
    return attributes;
}

- (NSDictionary *)linktAttribute {
    NSDictionary * attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName: [UIColor blueColor], NSUnderlineStyleAttributeName: @1, NSUnderlineColorAttributeName: [UIColor blueColor]};
    return attributes;
}


#pragma mark - CTRunDelegateCallBack c函数回调
static CGFloat getAscent(void * ref) {
    float height = [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
    return height;
}

static CGFloat getDescent(void *ref) {
    return 0;
}

static CGFloat getWidth(void * ref) {
    float width = [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
    return width;
}

@end
