---
title: UI视图
date: 2019-02-19 11:18:03
tags: UI视图
categories: iOS进阶
description: TableView的cell复用机制、数据源同步问题、事件传递、图像的显示原理(异步绘制、离屏渲染)
---

#### TableView 
##### cell复用策略
总结来说：
1、tableView在初始化时会同时创建一个空的复用池，之后在内部 维护着这个cell复用池。
2、复用池的方法一般有两种：
* 1、取出一个空的cell再新建一个。具体的api就是 **dequeueReusableCellWithIdentifier: **，使用这个消息提取cell，则取出来的cell是有可能为nil的，所以需要判断cell是否为空，否则就得创建：
```OC
UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@“indentifier”];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@“indentifier”];
    }
```
* 2、预先注册一个cell，之后再直接从复用池里取出来。具体的api就是**dequeueReusableCellWithIdentifier:forIndexPath:**，使用这个消息提取cell的前提是必须先通过tableView的register方法进行注册，使用register方法时，会先做cell的初始化同时添加进复用池。所以它不必做nil判断，因为取出来的cell是必定存在的。
```OC
//注册
[tableView registerClass:[UITableView class] forCellReuseIdentifier:@"Identifier"];
//使用
cell=[tableView dequeueReusableCellWithIdentifier:@"Identifier" forIndexPath:indexPath];
```
3、存入复用池和从复用池取出cell的时机是很重要的，当整个cell从屏幕的显示范围**完全移出**时，会将这个cell添加进重用池，或者使用register方法时就会同时被添加加复用池。(当然了，这个重用池肯定是使用Set来存储唯一用identifier的cell的)。当一个cell即将被显示时，则会去重用池查找是否有相关cell。
代码模拟一下复用池里的情况：
```OC
.h
// 实现重用机制的类
@interface ViewReusePool : NSObject
//取
- (UIView *)dequeuereusebleView;
//存
- (void)addUsingView:(UIView *)view;
//重置复用池
- (void)reset;
@end

.m
@interface ViewReusePool()
//等待使用的队列
@property (nonatomic, strong) NSMutableSet * waitUsedQueue;
//使用中的队列
@property (nonatomic, strong) NSMutableSet * usingQueue;
@end
@implementation ViewReusePool

- (instancetype)init
{
    self = [super init];
    if (self) {
        _waitUsedQueue = [NSMutableSet set];
        _usingQueue = [NSMutableSet set];
    }
    return self;
}


//取
- (UIView *)dequeuereusebleView {
    UIView * view = [_waitUsedQueue anyObject];
    if (view == nil) {
        return nil; //没有可重用的
    }else{
        //进行队列移动
        [_waitUsedQueue removeObject:view];
        [_usingQueue addObject:view];
        return view;
    }
}
//存
- (void)addUsingView:(UIView *)view {
    if (view == nil) {
        return;
    }
    [_usingQueue addObject:view];
}
//重置复用池
- (void)reset {
    UIView *view = nil;
    while ((view = [_usingQueue anyObject])) {
        //从使用队列中移除
        [_usingQueue removeObject:view];
        //添加进等待队列
        [_waitUsedQueue addObject:view];
    }
}

@end
```

##### 多线程下的数据源同步
**场景描述:**
UITableView有一个数据源dataSource。在弱网情况下，用户连续执行了两个操作，一个是下拉调起接口重新拉取DataSource里的数据，一个是在接口请求还没回来的情况下，左滑对某一条数据进行了删除。删除是在主线程下执行的，接口加载是在子线程下进行的。所以在接口请求回来后，给datasource进行复制的时候，就会把刚删除的数据重新赋值给DataSource。此时就产生了数据源同步的问题。

**解决的方案：**
1、将删除后的元数据进行拷贝，当接口数据回来之后，进行比对，剔除被删除的数据，然后再进行DataSource的赋值，最后回到主线程更新UI。
2、删除操作时，先对要删除的数据进行标识(实际先不进行删除)，然后在数据接口回来之后，再将数据进行删除，最后回到主线程更新UI。

#### 事件传递
* UIView 和 CALayer：
UIView有一个属性叫做layer，它所对应的类型就是CALayer类型，CALayer有个id类型的contents属性，它实际上对应着一个CGImageRef(位图)。实际上UIView的显示部分就是由CALayer的contents决定的，最终的显示可以理解为都是位图。
**UIView 的职责就是为CALayer提供内容，已经负责处理触摸登响应事件，参与响应链。而CALayer 的职责则是负责显示内容contents**。这实际上就是付合**单一职责**的设计原则。
* 事件传递：
当点击某一个view的时候，系统是如何判断是由哪个view来响应该事件的呢？
两个函数hitTest:withEvent: 和pointInside:withEvent: 。hitTest是返回最终响应事件的视图，pointInside用来判断某个事件是否在当前的视图范围内，如果在就返回YES。

1、假如我们点击了屏幕的某一个位置，则事件会传递给UIApplication管理的事件队列中；
2、UIApplication从队列中取出事件进行处理时，会将改事件传递给UIWindow。
3、UIWindow则会通过hitTest方法在视图层级中找到一个合适的view来处理事件，hitTest方法的大致处理流程大致如下：
	3.1 首先调用当前视图的pointInside:withEvent:方法判断触摸点是否在当前视图。若pointInside返回NO，则说明触摸点不在当前视图，hitTest返回nil；若返回YES，则会继续遍历当前视图的子视图，重复上述操作（视图遍历的顺序是倒序的，也就是从最上层开始查找，一旦找到就可以省去查找中间环节的视图）。直到有有非空的hitTest返回。

* 应用场景：
1、扩大UIButton的点击区域：上下左右各增加20
```OC
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(CGRectInset(self.bounds, -20, -20), point)) {
        return YES;
    }
    return NO;
}
```
2、子view超出了父view的bounds响应事件：正常情况下超出部分是不会响应事件的，因为在父view的pointInsert函数里过不了关，所以解决方案是重写父view的pointInsert方法。

* 视图响应链
如果说上面是事件传递机制的话，那么再找到view之后，最终决定谁来执行事件响应就是视图响应链了。视图响应链这是有从找到的子视图一直到最底部的父视图组成的一条链，意思是如果子view不对事件进行响应，则响应者就会被委托给父视图，以此类推。


#### 图像的显示原理
首先UI视图的显示是由CPU和GPU协作完成的。CPU的工作主要是负责UI布局、文本计算、位图的渲染及一些图片编解码的准备工作，最终位图将通过Core Animation框架提交给GPU。GPU的工作主要就是图层的渲染和纹理和合成，具体就包括顶点着色、光栅化等。GPU产生的最终结果将会放到帧缓冲区内，当视图控制器接收到VSync信号后，就会去帧缓冲区提取帧视图，最终显示在屏幕上。

##### 卡顿和掉帧 
视图屏幕的刷新周期就是一个VSync信号的发送周期，其实也是一个runloop的迭代周期，也就是60帧/s，相当于16.7ms左右。也就是说CPU和GPU的合成工作必须在一个VSync信号周期之内完成，否则就容易造成掉帧，掉帧最终也就导致了卡顿等性能问题。所以我们一般解决卡顿等性能问题都是从CPU和GPU两个方面入手！
* 对于CPU，我们可以将一些较耗时的对象生成释放、文本高度计算等放到子线程中，亦或进行**异步绘制**实现。
* 对于GPU，就要尽量避免**离屏渲染**。

#####  绘制原理&异步绘制
1、异步绘制就是通过实现layer的delegate方法：displayer，displayer方法里调用Core Graphics的API实现Bitmap的绘制，最后回到主线程给layer的contents进行赋值。这样就实现了异步绘制。

2、设置CALayer的drawsAsynchronously为YES时，-drawRect:/drawInContext:里的绘制指令会延迟到延迟到后台线程里异步执行。



##### 离屏渲染

GPU的渲染分为：当前屏幕渲染、离屏渲染。当前屏幕渲染就是指在用于显示的屏幕缓冲区中进行，不需要额外创建新的缓冲，也不需要开启新的上下文，所以性能较好。但是受到缓存大小限制等因素，一些复杂的操作无法在当前屏幕及时完成（为什么无法完成？因为有些属性或者混合体在未 预合成之前不能直接在屏幕中绘制，所以需要在显示之前在屏幕外上下文中先被渲染）。所以就需要在当前屏幕缓冲区以外新开辟一个新的缓冲区进行渲染操作。这就是离屏渲染。

所以相对于当前屏幕渲染，离屏渲染所消耗的性能就是在：1、创建新的缓存区；2、上下文切换（指环境的变换。比如，先从当前屏幕切换到离屏，等待离屏渲染结束后，将离屏缓冲区的结果显示到屏幕上，这又需要将上下文环境从离屏切换到当前屏幕）。

那什么情况下会触发离屏渲染？
1、设置图层的圆角，且maskToBounds为YES时，会触发
2、设置视图的图层蒙版
3、阴影的设置
4、光栅化设置
5、抗锯齿
6、不透明

那如何避免离屏渲染呢？
为了避免卡顿问题，应当尽量避免使用layer的border、corner、shadow、mask等技术。但是必须使用离屏渲染时，相对简单的视图应该使用CPU渲染，相对复杂的视图则应该使用一般的离屏渲染。

那什么是CPU渲染呢？
由于GPU的浮点运算比CPU强，CPU渲染的效率可能不如离屏渲染。但是如果是一些简单的效果，则CPU渲染可能比离屏渲染好。一个常见的CPU渲染的例子就是：重写drawrect方法，并且使用任何Core Graphics的技术进行绘制操作，就涉及到了CPU渲染。





