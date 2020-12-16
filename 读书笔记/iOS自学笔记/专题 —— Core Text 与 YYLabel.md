---
title: iOS-技能知识小集
date: 2020-12-7 18:36:48
tags: Core Text
categories: iOS进阶
description: 学习Core Text 及 YYLabel 对 Core Text的封装 ，为处理卡顿优化打基础。

---

### Core Text 
Core Text是一种高级的底层技术，用于布局文本和处理字体。
#### 基础
##### 基础框架
* CTFrame
表示一段内容或一块区域。通常包含一个或多个CTline。
常用API：
	* CTFrameGetLines：获取CTFrame中所有的CTLine
	* CTFrameGetLineOrigins：获取CTFrame中每一行的起始坐标，返回结果
	* CTFrameDraw: 把CTFrame绘制到Context上下文
* CTLine
表示一行内容。通常包含一个或多个CTRun。
常用API：
	* CTLineGetGlyphRuns：获取CTLine包含的所有CTRun
	* CTLineGetOffsetForStringIndex：获取CTRun的起始位置
* CTRun
表示每一行中，相同格式的一块内容。这个内容可以是文本，也可以是图片。
常用API：
	* CTRunGetAttributes：获取CTRun保存的属性，获取到的内容通过CFAttributeStringSetAttribute方法设置给图片属性字符串的NSDictionary，key为KCTRunDelegateAttributeName，指为CTRunDelegateRef
	* CTRunGetTypographocBounds：获取CTRun的绘制属性 ascent、desent，返回值为CTRun的宽度
	* CTRunGetStringRange：获取CTRun字符串的Range
* CTRunDelegate
CTRunDelegate和CTRun是紧密相连的，CTFrame初始化的时候需要用到的图片信息是通过CTRunDelegate的callback获得的
常用API：
	* CTRunDelegateCreate 创建CTRunDelegate对象，需要传递CTRunDelegateCallbacks对象，使用CFAttributedStringSetAttribute方法把CTRunDelegate对象和NSAttributedString对象绑定，在CTFrame初始化的时候用CTRunDelegate回调方法返回Ascent、descent、width等信息。

* 坐标系
iOS 开发时，使用的UIKit的坐标系的原点是在**左上角**。Core Text的坐标系原点是**左下角**。
所以通常在使用Core Text之前需要进行坐标转换。
```
	// 坐标系转换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
```

####  绘制文本

绘制文本流程：
步骤：1、创建文本绘制区域 ——> 2、创建文本属性 ——> 3、创建CTFrame ——> 4、绘制
```
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
```

#### 绘制图片
其实CoreText不直接参与图片的绘制。图片的绘制工作还是直接调用CoreGraphic的API进行绘制。
```
CGContextDrawImage(context, item.frame, [UIImage imageNamed:item.imgName].CGImage)
```
但是重点就在于，图片的frame的计算。尤其是图文混排里的图片。

计算的过程：通过Frame获取所有的line，再通过line获取run，然后通过run获取rundelegate，再从rundelegate里拿到原始数据（因为是图文混排，所以图片的起始位置实际是紧贴前一个CTRun，所以原始数据只需要设置size就好了）。其次再通过line来获取到origin，最后确定图片的frame。

关键代码：

```

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

```

计算图片的位置

```
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
```

#### 内容高亮与事件处理

Core Text的点击事件，也是通过获取Touch的地址，然后去查找对应的CTRun。找到后决定是否处理点击事件。





Core Text学习参考

[Core Text进阶](https://my.oschina.net/FEEDFACF/blog/1846672)

[Core Text制作杂志](https://www.jianshu.com/p/f10dac7a0c9f)

[Core Text框架详解](https://www.jianshu.com/p/e7b14e221ea0)

[Core Text编程指南](https://juejin.im/post/5c5154e9e51d4503834dabf4)



YYText学习资料

[YYText 与 Core Text](https://cloud.tencent.com/developer/article/1403845)

[YYLabel github](https://github.com/ibireme)

[AsyncDisplayKit学习资料](https://juejin.cn/post/6844903466259709960)

