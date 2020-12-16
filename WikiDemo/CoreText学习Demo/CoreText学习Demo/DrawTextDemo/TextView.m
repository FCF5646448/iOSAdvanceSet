//
//  TextView.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/15.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "TextView.h"
#import <CoreText/CoreText.h>

@implementation TextView

/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
*/

/*
 绘制文本
 步骤：
 1、创建文本绘制区域
 2、创建文本属性
 3、创建CTFrame
 4、绘制
 
 说明：
 Core Text：
 1、使用AttributeString来管理文本和属性；
 2、相同属性和方向的连续字形会生成CTRun；
 3、CTLine表示一行文本。所以它会包含一个或多个CTRun；
 4、CTFrame表示一块文本区域。所以它至少包含一个CTline或CTrun。
 5、CTFramesetter用于将属性文本生成文本框。也就是说CTFrame是由CTFramesetter结合区域生成的。
 
 */
- (void)drawRect:(CGRect)rect {
    // drawRect是在drawInContext函数里调用的，drawInContext函数会先开辟一个后备缓存，所以这里可以使用CG的get函数获取到当前上下文。
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 坐标系转换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    //绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    //属性文本。NSMutableAttributedString可以同时保存文本和属性，可以应对任意类型的文本。
    NSDictionary * attri = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName: [UIColor blueColor]};
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:@"hello world ！" attributes:attri];
    
    // 创建CTFrame
    // CTFramesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrStr.length), path, NULL);
    
    // 绘制
    CTFrameDraw(frame, context);
}


@end
