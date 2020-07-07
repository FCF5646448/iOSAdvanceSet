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
CALayer有一个id类型的**contents**属性，在iOS中实际对应一个CGImageRef指针，它指向一个CGImage结构体，也就是一张位图。实际上UIView的显示最终就是显示这张位图。所有生成UIView的过程实际上就是给contents赋值CGImage的过程。
* contentGravity ： 是指内容的显示方式，与contentMode是对应的值，主要用于图片拉伸；
* contentsScale：寄宿图的像素尺寸和视图大小的比例；
* maskToBounds：是否需要显示超出边界的内容；(Q1：为什么会绘制出超出边界的内容？)
* contentsRect：0~1的图层子阈，左上角是0，右下角是1。比如{0，0，0.5，0.5}那就是整个Layer的左上角那四分之一。主要用于多个图片拼合成一张的情况；这样一次性打包载入到一张大图上比多次载入不同的图片在内存使用、渲染等方面要好很多；
* contentsCenter：定义可拉伸区域，比如点九图。默认情况下，contentsCenter是{0，0，1，1}，意味着拉伸区域是整个图层，然后均匀拉伸。如果contentsCenter是{0.25，0.25，0.5，0.5}，那么拉伸区域就正好是距离各边界25%的中间区域；

##### 绘制
首先每一个UIView都自带一个**只读**属性的CALayer，其主要负责显示和动画操作。然后CALayer有一个可选的delegate属性，实现了 CALayerDelegate 协议。在正常情况下，我们使用UIView的时候，其都是使用自带的Layer来进行绘制，它默认是将layer.delegate设置为自身的。所以如果我们使用了寄宿了视图的图层，那么是没法实现displayLayer等layer.delegate的。

除了可以给contents赋值已生成的CGImage，还可以直接使用Core Graphics的API来绘制。

* 首先UIView自带一个CALayer，当使用UIView自带的layer时。UIView会将  当视图层发送变化，或者手动调用了UIView的setNeedsDisplay方法，会调用CALayer的同名方法setNeedsDisplay，但是并不会马上进行绘制，而是将CALayer打上脏标记，放到一个全局容器里，等到Core Animation监听到RunLoop的BeforWaiting或exit状态后，会将全局容器里的CALayer执行display方法。CALayer有一个delegate属性，当执行执行display方法时，首先会判断是否实现了layer.delegate的displayLayer：方法，如果实现了，就调用displayLayer：方法，然后在方法里设置contents。否则CALayer就会调用displayContents:方法，然后在该方法内部会先开辟一个


### 动画
### image I/O




