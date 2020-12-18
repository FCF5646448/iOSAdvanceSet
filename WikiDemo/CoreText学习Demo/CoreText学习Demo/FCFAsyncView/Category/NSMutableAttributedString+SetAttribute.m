//
//  NSMutableAttributedString+SetAttribute.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/18.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "NSMutableAttributedString+SetAttribute.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


@implementation NSMutableAttributedString (SetAttribute)

- (void)fcf_setTextColor:(UIColor*)color {
    [self fcf_setTextColor:color range:NSMakeRange(0, [self length])];
}

- (void)fcf_setTextColor:(UIColor*)color range:(NSRange)range {
    if (color.CGColor) {
        [self removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
        [self addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
    }
}

- (void)fcf_setFont:(UIFont*)font {
    [self fcf_setTextColor:font range:NSMakeRange(0, [self length])];
}

- (void)fcf_setFont:(UIFont*)font range:(NSRange)range {
    if (font) {
        [self removeAttribute:(NSString *)kCTFontAttributeName range:range];
        
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, nil);
        if (nil != fontRef) {
            [self addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
            CFRelease(fontRef);
        }
    }
}
@end
