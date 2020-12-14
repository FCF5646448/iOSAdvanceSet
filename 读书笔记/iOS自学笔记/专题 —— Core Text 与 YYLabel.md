---
title: iOS-技能知识小集
date: 2020-12-7 18:36:48
tags: Core Text
categories: iOS进阶
description: 学习Core Text 及 YYLabel 对 Core Text的封装 ，为处理卡顿优化打基础。

---

#### Core Text 

上述异步绘制中设计到CoreText，所以这里简单介绍一下：
三个类：CTFrameRef: 画布；CTLineRef: 每一行；CTRunRef:每一小段。
每个画布(CTFrameRef)可以包含多行(CTLineRef)，每一行可以包含多个小段(CTRunRef)。
绘制步骤：
首先一般的绘制都是异步绘制，所以基本是在display函数或者drawRect函数中。因为这样才能拿到context

```
	//
	CGContextRef context = UIGraphicsGetCurrentContext();
	//变换坐标
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	//设置绘制的路径
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, self.bounds);
	/创建属性字符串
	NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str4];
	
	//颜色
	[attStr addAttribute:(__bridge NSString *)kCTForegroundColorAttributeName value:(__bridge id)[UIColor redColor].CGColor range:NSMakeRange(5, 10)];
	
	//字体
	UIFont * font = [UIFont systemFontOfSize:25];
	CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, 25, NULL);
	[attStr addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(20, 10)];
	
	//空心字
	[attStr addAttribute:(__bridge NSString *)kCTStrokeWidthAttributeName value:@(3) range:NSMakeRange(36, 5)];
	[attStr addAttribute:(__bridge NSString *)kCTStrokeColorAttributeName value:(__bridge id)[UIColor blueColor].CGColor range:NSMakeRange(37, 10)];
	
	//下划线
	[attStr addAttribute:(__bridge NSString *)kCTUnderlineStyleAttributeName value:@(kCTUnderlineStyleSingle | kCTUnderlinePatternDot) range:NSMakeRange(45, 15)];
	
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
	CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attStr.length), path, NULL);
	
	//绘制内容
	CTFrameDraw(frame, context);
```

[Core Text编程指南](https://juejin.im/post/5c5154e9e51d4503834dabf4)



[Core Text]https://raojunbo.github.io/15526311929031.html

[Core Test 基础](https://blog.devtang.com/2015/06/26/using-coretext-1/)

[COre Text进阶](https://blog.devtang.com/2015/06/26/using-coretext-2/)

[YYText 源码剖析](https://cloud.tencent.com/developer/article/1403845)





https://cloud.tencent.com/developer/article/1403845



https://juejin.cn/post/6844903466259709960



https://github.com/ibireme