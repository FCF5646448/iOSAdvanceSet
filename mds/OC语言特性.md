---
title: OC语言特性
date: 2019-02-19 11:18:03
tags: OC特性
categories: iOS进阶
description: 
---

#### 分类Category
category在开发中主要的作用是给类添加实例方法，但其实苹果还推荐我们：
1、使用category将类的实现分开在几个不同的文件里面，这样做的可以减少单个文件的体积、把不同的功能组织到不同的category里，由多个开发者共同开发一个类，按需加载想要的category。
2、声明私有方法。
另外，开发者还给出了几个使用场景：
1、模拟多继承
2、把framework的私有方法公开

* 分类是运行时决议的。它可以为宿主类添加属性(通过实现setter和getter方法)、实例方法、类方法、协议。
* category方法没有完全替换掉原来类中已有的同名方法，只是方法被放在了新方法列表的前面。
* category中可以添加+load方法，那多个category中是否可以同时添加+load方法，调用顺序又是怎样的呢？
答案是可以调用，执行顺序是先宿主类，后category。而category之间的+load方法则是根据编译顺序来决定的。

#### category + 关联：
category无法为类添加实例变量，若要实现为类添加实例变量，则可以使用关联对象。
objc_setAssociatedObjct , objc_getAssociatedObjct
**关联对象都是由AssociationsManager管理**，AssociationsManager里面由一个静态AssociatiosHasMap来存储所有的关联对象。

扩展Extension


KVC

KVO
