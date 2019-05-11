---
title: UI视图
date: 2019-02-19 11:18:03
tags: UI视图
categories: iOS进阶
description: 。
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

*视图响应链
https://www.jianshu.com/p/2e074db792ba



图像的显示原理

卡顿和掉帧

attribute
圆角与maskToBounds共同使用



#### 绘制原理&异步绘制

#### 离屏渲染

