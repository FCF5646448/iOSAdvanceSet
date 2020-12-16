//
//  ImageView.m
//  CoreText学习Demo
//
//  Created by 冯才凡 on 2020/12/15.
//  Copyright © 2020 冯才凡. All rights reserved.
//

#import "ImageView.h"
#import <CoreText/CoreText.h>


@implementation ImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

- (void)drawRect:(CGRect)rect {
    
    // 翻转坐标系
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    // 上下文绘制 frame
    CTFrameDraw(self.data.ctFrame, context);
    
    // 上下文中绘制图片
    for (int i = 0; i < self.data.images.count; i++) {
        ImageItem * item = self.data.images[i];
        CGContextDrawImage(context, item.frame, [UIImage imageNamed:item.imgName].CGImage);
    }
    
}

@end
