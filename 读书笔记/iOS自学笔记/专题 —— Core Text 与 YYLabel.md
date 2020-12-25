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
**Core Text的布局通常由属性字符串(CFAttributedStringRef)和图形路径(CGPathRef)共同完成。属性字符串包含需要绘制的字符串、字符的样式属性；图形路径定义了文本绘制区域的形状。**

​	属性字符串字体、颜色、阴影、行间距、对齐、段间距、下划线都可以处理。

* 工作流程：
	CTFramesetterRef通过属性字符串CFAttributedStringRef和图形路径CGPathRef，生成一个或多个CTFrameRef。每个CTFrameRef表示一个段落。
	在CTFrameRef的生成过程中，CTFramesetterRef会调用CTTypesetterRef将属性字符串及其属性(对齐、行间距、缩进、字体等)转成多个相应的CTRun，并将其填充到CTLine中。(CTRline可以直接绘制在图像上下文中，大多数时候，无需直接操作CTRun)。

##### 主要的类
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

* CTRunDelegateRef

  CTRunDelegateRef可以实例一个空白的区域。可以通过它来预留图片、自定义视图的位置。从而达到图文混排的效果。
  常用API：

  * CTRunDelegateCreate 创建CTRunDelegate对象，需要传递CTRunDelegateCallbacks对象，使用CFAttributedStringSetAttribute方法把CTRunDelegate对象和NSAttributedString对象绑定，在CTFrame初始化的时候用CTRunDelegate回调方法返回Ascent、descent、width等信息。

* CTFont

  字体对象，包含了很多字体直接的东西。比如字号、字形、上下行行高等。


* 坐标系
iOS 开发时，使用的UIKit的坐标系的原点是在**左上角**。Core Text的坐标系原点是**左下角**。
所以通常在使用Core Text之前需要进行坐标转换。
```
	// 坐标系转换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
```

#### 简单Demo
#####  绘制文本

绘制文本流程：
步骤：1、创建文本绘制区域 ——> 2、创建文本属性 ——> 3、创建CTFrame ——> 4、绘制CTFrame

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

##### 绘制图片
**其实CoreText不直接参与图片的绘制，首先通过CTRunDelegate中的原始数据来创建用于占位使用的图片属性字符串。然后将图片属性字符串与文本字符串一起生成属性字符串。然后通过属性字符串生成CTFramesetter，再由CTFramesetter生成CTFrame。再绘制CTFrame之前，会根据属性字符串里的CTLine、CTRun等元素对图片的frame进行重新计算和调整。最后在绘制完CTFrame之后，图片的绘制工作还是直接调用CoreGraphic的API进行绘制。**

```
CGContextDrawImage(context, item.frame, [UIImage imageNamed:item.imgName].CGImage)
```
计算的过程：**通过Frame获取所有的line，再通过line获取run，然后通过run获取Attributes，再从Attributes 获取到CTRunDelegate，最后从rundelegate里拿到原始数据，同时从CTRun和CTLine里获取到起始位置和上下行高。**（因为是图文混排，所以图片的起始位置实际是紧贴前一个CTRun，所以原始数据只需要设置size就好了）。**最后更新图片的frame。**

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

##### 事件处理

事件处理的话，需要先通过touchBegin等手势识别函数获取到点击的位置。然后再判断手势的位置是对应哪个具体的CTRun以及CTRun是否可点击。

##### 文字行数限制和截断设置

* 行数限制：
  如果是不限制行数，那么默认是调用CTFrameDraw接口对CTFrame进行绘制。如果是有行数限制，那么就调用CTLineDraw接口对每一行进行绘制。

  所以如果是有行数限制，在绘制之前，首先要通过CTFrame获取到所有的CTLine。然后根据需要显示的行数来迭代计算每一行的位置。

* 截断设置：

  截断设置是指如果有行数限制且整体区域超过了限制的大小。那就就会对最后一行进行处理。通常默认是"…"来作为截断显示，也有可能通过自定义的按钮或文本来显示截断区域。

  所以最后一行如果需要添加截断元素时。首先要生成截断属性字符串（NSAttributeString）以及计算出切断属性字符串所需的frame。然后获取原最后一行的内容字符串对截断区域的内容进行裁剪，然后拼接截断属性字符串。最后更新最后一行的frame。

  完成这项操作后，就可以调用CTLineDraw对每一行进行绘制了。

##### 手动布局与自动布局

* 手动布局：

  手动布局需要重写UIView的sizeThatFits方法，返回真实内容所需的CGSize。

  首先CTFramesetterSuggestFrameSizeWithConstraints方法可以计算指定范围内容大小。所以如果是不限行数，那么传入一个空的Range对象，就可以直接计算出所有内容区域size。如果限制了行数，则可以通过CTLineGetStringRange获取最后一行的内容显示范围，进而获取显示范围内的区域size。

* 自动布局：

  自动布局底层会调用intrinsicContentSize获取内容的大小。所以重写这个方法，然后再调用上面的sizeThatFits方法获取内容大小返回。

  但是需要注意的是。使用这种方法去计算自动布局的大小需要一个size的width。所以在设置约束之前，最后先给一个含有width的frame。

  ```
  FCFDrawView *textDrawView = [[FCFDrawView alloc] initWithFrame:CGRectZero];
  textDrawView.backgroundColor = [UIColor whiteColor];
  textDrawView.text = @"自动布局限制高度：\n这是一个最好的时代，也是一个最坏的时代；这是明智的时代，这是愚昧的时代；这是信任的纪元，这是怀疑的纪元；这是光明的季节，这是黑暗的季节；这是希望的春日，这是失望的冬日；我们面前应有尽有，我们面前一无所有；我们都将直上天堂，我们都将直下地狱。";
  textDrawView.textColor = [UIColor redColor];
  textDrawView.font = [UIFont systemFontOfSize:16];
  // 这一步很重要，需要传递一个frame，其实在自动布局模式下只要用到width,其它值为0即可
  textDrawView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
  [self addSubview:textDrawView];
  [textDrawView mas_makeConstraints:^(MASConstraintMaker *make) {
  	make.left.right.equalTo(self);
  	make.top.equalTo(self).offset(400);
  	make.height.mas_equalTo(64);
  }];
  ```

##### 添加自定义View

处理自定义View的方法与图片类似，都是先计算frame，然后使用addSubView将子视图添加进去（图片是使用CoreGraphic 的API：CGContextDraw将图片绘制上去）。

##### 绘制阴影、边框

不直接使用CoreText绘制阴影和边框，而是直接使用CoreGraphics绘制图片、阴影、边框等。



### YYText

YYText的核心优化是**异步绘制**。但其实它最复杂就是对CoreText的运用。
为了线程安全，UIKit的UI组件都必须在主线程绘制。当绘制内容多大的话，容易造成界面卡顿。
YYText的核心思路就是：在异步线程中创建(获取)图形上下文，然后利用CoreText绘制富文本，利用CoreGraphics绘制图片、阴影、边框等。最后将绘制完成的位图放到主线程中显示。
但是图文混排中最复杂的地方就在于位置的计算。包括图片的位置、截断的位置等。

* 主要绘制类：
  YYText封装了YYTextRunDelegate来管理附件占位信息；
  封装了YYTextLine来对Line和Run进行管理和计算；
  封装了一个YYTextAttachment来管理附件信息（图片、子视图），以方便位置计算，有了它也方便实现图文混排；
  封装了一个YYtextContainer类对path进行管理，使得YYText支持各种Path来设置内容区域，比如exclusion path 的镂空效果；
  封装了一个YYTextLayout核心计算类，计算每一个Run和每一个line的frame，计算附件占位内容、截断内容的frame等。
  封装了自己的属性字符串的一些富文本属性，如果不是CoreText能识别出来的key，那么就会通过其他方法进行绘制。

* 异步绘制YYAsyncLayer：
  [YYSyncLayer异步绘制](https://www.jianshu.com/p/154451e4bd42)
  异步绘制就是将原本在主线程的UI的绘制工作放到异步子线程中进行。
  通过CALayer的子类YYAsyncLayer进行异步绘制。
  概述：在异步线程创建一个位图上下文，调用task的display代码块进行绘制（业务代码），然后生成一个位图，最终进入主队列给YYAsyncLayer的contents赋值CGImage由 GPU 渲染过后提交到显示系统。
  1、通过计数器结束无关紧要的绘制。主要是在手动调用了setNeedsDisplay的时候设置取消掉当前绘制。
  2、异步线程的管理：
  	1、最大队列数是16；
  	2、串行队列的数量与处理器数量相同
  	3、串行队列，设置优先级。低于用户交互优先级，避免与主线程竞争资源。

* 通过YYTransaction来管理一系列绘制任务。
  首先YYTransaction监听了主线程RunLoop的BeforeWaiting和Exit两个状态。

  

Core Text学习参考

[Core Text进阶](https://my.oschina.net/FEEDFACF/blog/1846672)

[Core Text制作杂志](https://www.jianshu.com/p/f10dac7a0c9f)

[Core Text框架详解](https://www.jianshu.com/p/e7b14e221ea0)

[Core Text编程指南](https://juejin.im/post/5c5154e9e51d4503834dabf4)



YYText学习资料

[YYText 与 Core Text](https://cloud.tencent.com/developer/article/1403845)

[YYLabel github](https://github.com/ibireme)

[AsyncDisplayKit学习资料](https://juejin.cn/post/6844903466259709960)

