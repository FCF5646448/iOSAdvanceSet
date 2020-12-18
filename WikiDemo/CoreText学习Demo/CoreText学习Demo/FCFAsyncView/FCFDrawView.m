//
//  FCFDrawView.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/18.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "FCFDrawView.h"
#import "FCFRichContentData.h"

const NSInteger COVER_TAG = 100023;

@interface FCFDrawView()
@property (nonatomic, strong) FCFRichContentData *data;
@property (nonatomic, strong) FCFBaseDataItem *clickedItem;
@end

@implementation FCFDrawView

- (FCFRichContentData *)data {
    if (!_data) {
        _data = [FCFRichContentData new];
    }
    return _data;
}

#pragma MARK - inteface
- (void)addString:(NSString *)string attribute:(NSDictionary *)attribute clickActionHandler:(ClickActionHandler)clickActionHandler {
    [self.data addString:string attribute:attribute clickActionHandler:clickActionHandler];
}

- (void)addLink:(NSString *)link clickActionHandler:(ClickActionHandler)clickActionHandler {
    [self.data addLink:link clickActionHandler:clickActionHandler];
}

- (void)addImage:(UIImage *)image size:(CGSize)size clickActionHandler:(ClickActionHandler)clickActionHandler {
    [self.data addImage:image size:size clickActionHandler:clickActionHandler];
}

- (void)addView:(UIView *)view size:(CGSize)size clickActionHandler:(ClickActionHandler)clickActionHandler {
    [self addView:view size:size align:FCFAttachmentAlignTypeBottom clickActionHandler:clickActionHandler];
}

- (void)addView:(UIView *)view size:(CGSize)size align:(FCFAttachmentAlignType)align clickActionHandler:(ClickActionHandler)clickActionHandler {
    [self.data addView:view size:size align:align clickActionHandler:clickActionHandler];
}


- (void)setNumOfLines:(NSInteger)numOfLines {
    self.data.numOfLines = numOfLines;
    [self setNeedsDisplay];
}

#pragma MARK - Override
- (CGSize)sizeThatFits:(CGSize)size {
    NSAttributedString *drawString = self.data.attributeStringToDraw;
    if (drawString == nil) {
        return CGSizeZero;
    }
    
    CFAttributedStringRef attriStringRef = (__bridge CFAttributedStringRef)drawString;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attriStringRef);
    CFRange range = CFRangeMake(0, 0);
    if (_numOfLines > 0 && framesetter) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef lines = CTFrameGetLines(frame);
        
        if (nil != lines && CFArrayGetCount(lines) > 0) {
            NSInteger lastVisibleLineIndex = MIN(_numOfLines, CFArrayGetCount(lines)) - 1;
            CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);
            
            CFRange rangToLayout = CTLineGetStringRange(lastVisibleLine);
            range = CFRangeMake(0, rangToLayout.location + rangToLayout.length);
        }
        CFRelease(frame);
        CFRelease(path);
    }
    
    CFRange fitCFRange = CFRangeMake(0, 0);
    CGSize newSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, NULL, size, &fitCFRange);
    if (framesetter) {
        CFRelease(framesetter);
    }
    return newSize;
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)];
}


#pragma MARK - draw
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    //
    [self.data composeDataToDrawWithBounds:self.bounds];
    
    [self drawShadowInContext:context];
    
    [self drawTextInContext:context];
    
    [self drawAttachmentInContxt:context];
}

- (void)drawTextInContext:(CGContextRef)context {
    if (self.data.drawMode == FCFDrawModeFrame) {
        CTFrameDraw(self.data.drawFrame, context);
    }else if (self.data.drawMode == FCFDrawModeLines) {
        for (FCFCTLine *line in self.data.drawLines) {
            CGContextSetTextPosition(context, line.position.x, line.position.y);
            CTLineDraw(line.ctLine, context);
        }
    }
}


- (void)drawAttachmentInContxt:(CGContextRef)context {
    for (int i = 0; i<self.data.attachments.count; i++) {
        FCFAttachmentItem *attachmentItem = self.data.attachments[i];
        if (attachmentItem.type == FCFAttachmentTypeImage) {
            if (attachmentItem.image) {
                CGContextDrawImage(context, attachmentItem.frame, attachmentItem.image.CGImage);
            }
        }else if (attachmentItem.type == FCFAttachmentTypeView) {
            if (attachmentItem.view) {
                attachmentItem.view.frame = attachmentItem.frame;
                [self addSubview:attachmentItem.view];
            }
        }
        
    }
}

- (void)drawShadowInContext:(CGContextRef)context {
    if (self.data.shadowColor == nil || CGSizeEqualToSize(self.data.shadowOffSet, CGSizeZero)) {
        return;
    }
    CGContextSetShadowWithColor(context, self.data.shadowOffSet, self.data.shadowAlpha, self.data.shadowColor.CGColor);
}

#pragma MARK - Gesture
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = event.allTouches.anyObject;
    if (touch.view == self) {
        CGPoint point = [touch locationInView:touch.view];
        FCFBaseDataItem *clickedItem = [self.data itemAtPoint:point];
        self.clickedItem = clickedItem;
        if (clickedItem) {
            for (NSValue *frameValue in clickedItem.clickableFrames) {
                CGRect clickedPartFrame = frameValue.CGRectValue;
                UIView *coverView = [[UIView alloc] initWithFrame:clickedPartFrame];
                coverView.tag = COVER_TAG;
                coverView.backgroundColor = [UIColor colorWithRed:0.3 green:1 blue:1 alpha:0.3];
                coverView.layer.cornerRadius = 3;
                [self addSubview:coverView];
            }
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (self.clickedItem.clickActionHandler) {
//        self.clickedItem.clickActionHandler(_clickedItem);
//    }
    
    !self.clickedItem.clickActionHandler ?: self.clickedItem.clickActionHandler(_clickedItem);
    self.clickedItem = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       for (UIView *subView in self.subviews) {
           if (subView.tag == COVER_TAG) {
               [subView removeFromSuperview];
           }
       }
    });
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.clickedItem = nil;
    [self touchesEnded:touches withEvent:event];
}



@end
