---
title: iOS-技能知识小集
date: 2020-7-3 17:36:48
tags: knoeledgePoints
categories: iOS进阶
description:  阅读《iOS Core Animation》笔记摘要。补充一下iOS视图渲染相关的疑问。
---

### 显示
UIView及其子视图组成的视图层级关系，称之为**视图树**；与UIView的层级关系形成的一种平行的CALayer的层级关系，称之为**图层树**。
#### CALayer及其属性
**CALayer怎么进行绘制**
CALayer有一个id类型的**contents**属性，在iOS中实际对应一个CGImageRef指针，它指向一个CGImage结构体，也就是一张位图。实际上UIView的显示最终就是显示这张位图。所有生成UIView的过程实际上就是给contents赋值CGImage的过程。
* contentGravity ： 是指内容的显示方式，与contentMode是对应的值，主要用于图片拉伸；
* contentsScale：寄宿图的像素尺寸和视图大小的比例；
* maskToBounds：是否需要显示超出边界的内容；(Q1：为什么会绘制出超出边界的内容？)
* contentsRect：0~1的图层子阈，左上角是0，右下角是1。比如{0，0，0.5，0.5}那就是整个Layer的左上角那四分之一。主要用于多个图片拼合成一张的情况；这样一次性打包载入到一张大图上比多次载入不同的图片在内存使用、渲染等方面要好很多；
* contentsCenter：定义可拉伸区域，比如点九图。默认情况下，contentsCenter是{0，0，1，1}，意味着拉伸区域是整个图层，然后均匀拉伸。如果contentsCenter是{0.25，0.25，0.5，0.5}，那么拉伸区域就正好是距离各边界25%的中间区域；

#### 绘制
首先每一个UIView都自带一个**只读**属性的CALayer，其主要负责显示和动画操作。然后CALayer有一个可选的delegate属性，它是CALayerDelegate协议的代理。在正常情况下，我们使用UIView的时候，它都是使用自带的Layer来进行绘制，默认是将layer.delegate设置为自身，然后在内部对contents进行赋值。(ps：所以我们想要对cell做异步绘制，是没法通过cell的layer来真实实现的，而是使用其他的UIView按照异步绘制的方式进行实现，比如YYKit中使用UIView的子类，在setText的时候开辟子线程进行绘制流程)。其次UIView开放了drawRect:方法，也可以在这个方法里进行绘制操作。但是这将会更消耗性能（ps:原因看下文）。
但是如果是直接使用CALayer，则可以通过实现layer.delegate的displayLayer方法来手动设置contents。
所以，一般的做法是：
* 要么直接使用UIView，如果要自定义绘制，就调用UIView的drawRect方法；
* 要么使用单独的CALayer，可以实现它的代理方法来实现自定义绘制工作；
* 或者使用UIView，然后在其他情况下开辟子线程进行绘制，最后给layer.contents进行赋值。

##### 绘制流程：
当视图层发送变化，或者手动调用了UIView的setNeedsDisplay方法，会调用CALayer的同名方法setNeedsDisplay，但是并不会马上进行绘制，而是将CALayer打上脏标记，放到一个全局容器里，等到Core Animation监听到RunLoop的BeforWaiting或Exit状态后，会将全局容器里的CALayer执行display方法。当执行执行display方法时，其方法内部首先会判断是否实现了layer.delegate的displayLayer：方法，如果实现了，就调用displayLayer：方法，然后在方法里设置contents。否则CALayer会先创建一个后备缓存(backing store)，然后调用displayContext:方法，其方法内部又会判断是否实现了layer.delegate的drawLayer:inContext:方法，如果实现了就执行drawLayer:inContext:方法，在该方法里设置contents；如果没有实现，就还是走系统的drawRect方法。
但是要注意：
* 在使用drawInContext之前，系统会开辟一个后备缓存（也就是绘制上下文），给drawRect：或者drawlayer：inContext：进行绘制使用，所以在UIView的drawRect方法中进行绘制工作不是最好的选择；
* 同理，在使用drawInContext之前，系统会开辟一个后备缓存（也就是绘制上下文）。所以在drawRect：或者drawlayer：inContext：方法中是可以直接获取上下文的，但是使用desplayLayer：则没法获取上下文，而是得手动创建一个上下文。

#### 排版
##### 布局
视图有三个比较重要的布局属性：frame、bounds、center。视图对应的layer也是这三个属性，可能center变成了position。
* frame：相对于父视图的坐标空间；它实际是根据bounds、position、transform计算而来，所以它们之间都是相互影响的；

* bounds：自身内部坐标空间，{0，0}表示左上角；

* center：CALayer对应position，代表相对于父视图anchorPoint所在位置；

  默认情况下(anchorPoint的默认值为 {0.5,0.5})，`position`的值便可以用下面的公式计算：

  ```
  position.x = frame.origin.x + 0.5 * bounds.size.width；  
  position.y = frame.origin.y + 0.5 * bounds.size.height；
  ```

* anchorPoint：锚点就是视图在执行变化的支点。通常情况下，锚点是在视图的正中心，值是{0.5,0.5}。（假设一张纸被一个图钉钉住，纸张围绕图钉做动画，那么这个图钉就是这个锚点）。总结来说：position 用来设置CALayer在父层中的位置，anchorPoint 决定着CALayer身上的哪个点会在position属性所指的位置。
  `frame、position与anchorPoint`有以下关系：

  ```
  frame.origin.x = position.x - anchorPoint.x * bounds.size.width；  
  frame.origin.y = position.y - anchorPoint.y * bounds.size.height；  
  ```

#### 视觉效果
* 圆角：conrnerRadius是指layer的曲率。默认情况下，conrnerRadius只影响背景色而不影响背景图片或子图层。所以如果要让其子图层或背景图片也响应这个曲率，则需要将maskToBounds设置成YES。
	* 离屏渲染：**正常情况下，如果单纯的对视图设置圆角，并设置maskToBounds是不会导致离屏渲染的，只有为视图添加了一个图片或者是一个有颜色、内容或边框等有图像信息的子视图才会触发离屏渲染。**；不过iOS9之后，苹果也做了一定的优化。如果Layer只设置了contents或者UIImageView只设置了image，次数设置conrnerRadius+maskTobounds是不会产生离屏渲染的。但是如果加上了背景色、边框或者其他图像内容的图层，还是会产生离屏渲染。可以理解为多层内容添加了圆角+裁剪才会触发离屏渲染，单层内容不会触发离屏渲染。所以我们给UIButton设置圆角+裁剪是会触发离屏渲染的，但是如果给UIButton的imageViei设置圆角+裁剪是不会触发离屏渲染。	
* 边框：图片边框由boarderWidth和boardColor定义。如果图层超出了边框，那么实际也是可以绘制出来的。
* 阴影：透明度shadowOpacity在[0,1]之间取值；shadowOffset设置阴影的方向和距离，默认值是(0，-3)，意思是阴影相对y轴有3个点的向上位移；shadowRadius设置阴影的模糊程度。
	* 阴影裁剪：图层的阴影不是根据边框和圆角来确定的，而是根据内容的外形，设置在layer的边界之外，也就是计算阴影的时候，会将其与寄宿图一起考虑。所以剪裁的时候阴影容易被剪切掉。所以解决方案就是：使用两个图层，一个是只画阴影的空的外图层，一个是使用了剪裁内容的内图层。
	* shadowPath：上述阴影剪裁的话，外图层其实得实时跟进内图层的形状，所以也是非常消耗资源的方案，尤其是多个子图层的时候。所以可以使用shadowPath来绘制阴影。
* 图层蒙版：layer的mask属性定义了layer的可见区域，它本身其实也是一个图层，所以可以给mask设置contents。
* 拉伸过滤：拉伸过滤算法就是将原图的像素根据需要生成新的像素显示在屏幕上；CALayer提供了三种拉伸过滤方法：kCAFilterLinear、kCAFilterNearest、kCAFilterTrilinear。
* 组透明：UIView有一个属性alpha，CALayer有一个属性opacity。这两个属性都是能影响子层级的。另外透明度混合叠加会导致子图层的透明度出现问题，可以使用shouldRasterize属性来处理。

#### 变换
* 仿射变换：transform用于对二维空间做旋转、缩放、平移等。底层实际就是对坐标进行矩阵运算。Core Graphics提供了一系列函数进行简单的变换：
```
CGAffineTransformMakeRotation(CGFloat angle); //旋转角度
CGAffineTransformMakeScale(CGFloat sx,CGFloat sy); //缩放
CGAffineTransformMakeTranslation(CGFloat tx,CGFloat ty); //平移
```
	* 混合变换：其实上述的每一个变换函数都会返回一个CGAffineTansform类型,可以对这个值进行连续变换：
	```
	//先缩小50%，再选择30度，然后右移200像素。
	CGAffineTransform transform = CGAffineTransformIdentity; 
	transform = CGAffineTransformScale(transform, 0.5, 0.5);
	transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 30.0);
	transform = CGAffineTransformTranslate(transform, 200, 0);
	self.layerView.layer.affineTransform = transform;
	```
	* 剪切变换：其实就是让视图倾斜的变换。
	```
	CGAffineTransform transform = CGAffineTransformIdentity; 		transform.c = -1; //以45度角倾斜这一层
	transform.b = 0;
	self.layerView.layer.affineTransform = CGAffineTransformMakeShear(1, 0);
	```
* 3D变换：其实就是在上述2D变换的基础上加上了一维Z轴。API都是CATransform3DMake...：
	```
	CATransform3DMakeRotation(CGFloat angle，CGFloat x，CGFloat y，CGFloat z); //旋转角度
	CATransform3DMakeScale(CGFloat sx,CGFloat sy,CGFloat sz); 	//缩放
	CATransform3DMakeTranslation(CGFloat tx,CGFloat ty,CGFloat sz); //平移
	```

	* 透视投影：m34属性用于修改transform的透视效果。m34默认值是0，通过设置m34为-1.0/d来应用透视效果，d代表想象中视角相机和屏幕直接的距离:
	```
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = -1.0/500/0;
	transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
	self.layerView.layer.transform = transform;
	```
	* 灭点：也就是相机离得足够远的位置，属性anchorPoint表示；
	* 背面：相当于对3D视图做180度旋转后的视角；

#### 专用图层
##### CAShapeLayer
CAShapeLayer是一个通过矢量图形而不是bitmap绘制的图层。它有一些优点：
* 渲染快速。它使用了硬件加速，比单纯的Core Graphics快很多；
* 高效使用内存。它无需像CALayer一样创建寄宿图形，所以无论多大都不会占用太多内存。
* 不会被边界裁剪。它可以在边界之外绘制，所以设置阴影可以使用它。
* 不会像素化。做变换时，不会被像素化。
通常使用CAShapeLayer是和UIBezierPath一起使用。
```
//设置圆角，可以单独指定每个角
CGRect rect = CGRectMake(50, 50, 100, 100);
CGSize radii = CGSizeMake(20, 20);
UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
UIBezierPath * path =  [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radi];
CAShapeLayer * shapeLayer = [CAShapeLayer layer];
shapeLayer.path = path.CGPath;
[self.containerView.layer addSublayer:shapeLayer];
```
##### CATextLayer
CATextLayer以图形的形式包含了UILabel几乎所有的绘制特性。它使用了Core Text,比UILabel渲染更快。但是CATextLayer并没有以retina的方式渲染，所以在高分辨率的屏幕上有点像素化了。通过设置contentScale可以解决这个问题。
```
CATextLayer * textLayer = [CATextLayer layer];
textLayer.frame = self.labelView.bounds;
[self.labelView.layer addSublayer:textLayer];
//设置attributes
textLayer.foregroundColor = [UIColor blackColor].CGColor; textLayer.alignmentMode = kCAAlignmentJustified; 
textLayer.wrapped = YES;
//设置字体
UIFont * font = [UIFont systemFontOfSize:15];
CFStringRef fontName = ( _ bridge CFStringRef)font.fontName; 
CGFontRef fontRef = CGFontCreateWithFontName(fontName); 
//textLayer.font = fontRef; 不是富文本可以直接这样设置字体
//textLayer.fontSize = font.pointSize;

NSString * text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. Quisque massa arcu, eleifend lonejajskjnk jkn jkjak  jkla ljlnansl lkan ";

NSMutableAttributedString * string = nil;
string = [[NSMutableAttributedString alloc] initWithString:text];
NSDictionary * attribs = @{
( _ bridge id)kCTForegroundColorAttributeName:( _ bridge id)[UIColor blackColor].CGColor,
( _ bridge id)kCTFontAttributeName: ( _ bridge id)fontRef 
};
[string setAttributes:attribs range:NSMakeRange(0, [text length])]; 
attribs = @{
( _ bridge id)kCTForegroundColorAttributeName: ( _ bridge id)[UIColor redColor].CGColor, ( _ bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
( _ bridge id)kCTFontAttributeName: ( _ bridge id)fontRef
};
[string setAttributes:attribs range:NSMakeRange(6, 5)];

//注意这个string不是NSString类型，而是一个id类型，所以可以设置NSString或NSAttributesString。
texxtLayer.string = string
//设置缩放
textLayer.contentsScale = [UIScreen mainScreen].scale;
```
但是真正的使用方式，不是直接使用CATextLayer，因为那太复杂了。考虑考虑继承自UILabel，然后添加一个子图层CATextLayer并重写显示文本的方法，但是这也同样需要重写drawRect方法，同时生成一个缓存区。所以也可以考虑直接使用UIView，重写layerClass方法创建一个CATextLayer。

##### CATransformLayer




### 动画

### image I/O





```

```