---
title: iOS-技能知识小集
date: 2020-7-3 17:36:48
tags: knoeledgePoints
categories: iOS进阶
description:  阅读《iOS Core Animation》笔记摘要。补充一下iOS视图渲染相关的疑问。
---

### 图层 
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
* 圆角
	
* 



### 动画

### image I/O




