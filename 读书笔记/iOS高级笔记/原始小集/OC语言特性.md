---
title: OC语言特性
date: 2019-02-19 11:18:03
tags: OC特性
categories: iOS进阶
description: 1、简述分类的实现原理，2、简述KVO的实现原理，3、简述通知的实现原理
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

#### 关联对象Associated
category无法为类添加实例变量，若要实现为类添加实例变量，则可以使用关联对象。
objc_setAssociatedObjct , 
objc_getAssociatedObjct，
objc_removeAssociatedObjects

**关联变量都是由AssociationsManager管理**，AssociationsManager里面由一个静态AssociatiosHasMap来存储所有的关联对象。AssociatiosHasMap里对应的key值是被管理对象指针值，value是一个ObjcAssociationMap对象。ObjcAssociationMap的key值则是添加时设置的key值，value则是一个ObjcAssociation对象，ObjcAssociation里包含了内容和属性标识符，如copy等。

####  扩展Extension
一般我们使用扩展声明私有属性、声明私有方法、声明私有成员变量。
扩展与分类的区别在于：
1、扩展是在编译时决议；
2、扩展只以声明的形式，多数情况下存在于宿主类的.m文件中
3、扩展不能作用于系统类

#### 代理:
1、注意循环引用
2、一对一传递方式
3、使用代理模式实现的

#### 通知
1、一对多的传递方式
2、使用观察者模式实现的，用于跨层传递消息
怎样实现通知机制
**NSNotificationCenter里面应该维护了一个Map表，key值应该就是notificationName，value则应该是一个list表，list中的每个元素应该包含了Observer和Selector**

#### KVO： key-value-observering
1、使用观察者模式
2、使用isa-swizzling技术来实现kvo：
kvo的实现细节：
**当我们给类A添加addObserver:forKeyPath:方法后，在运行时，系统会给类A生成一个NSKVONotifying_A的子类，同时将类A的isa指针指向NSKVONotifying_A，同时重新setter方法，以便通知所有观察者**。
重写的Setter方法：

```OC
- (void)setter:(id)obj {
    [self willChangeValueForKey:@"keyPath"];
    //
    [super setValue:obj];
    [self didChangeValueForKey:@"keyPath"];
}
```
q1: isa swizzling是怎么实现的？与method Swizzling有什么区别？
Method swizzling: 通过调用method_exchangeImplemantations来交换两个函数的method，达到方法交换：
```OC
Method originalMethod = class_getInstanceMethod(self, originalSelector);
Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
method_exchangeImplementations(originalMethod, swizzledMethod);
```
Isa swizzling：通过调用运行时API：Class object_setClass(id obj, Class cls)来实现的，具体步骤是：
* 调用runtime的API：objc_allocateClassPair动态创建和使用objc_registerClassPair注册一个子类；
* 调用runtime的API：object_setClass修改isa的指向；
* 调用runtime的API：class_addMethod给类动态添加方法，在子类中实现set方法。
```OC
//获取当前类
Class selfClass = self.class;
//动态创建KVO类
const char* selfClassName = NSStringFromClass(selfClass).UTF8String;
char kvoClassName[1000];
sprintf(kvoClassName,"%s%s","Test_KVO_",selfClassName);
Class subClass = objc_allocateClassPair(selfClass,kvoClassName,0);
objc_registerClassPair(kvoClass);
// 修改isa
object_setClass(self, kvoClass);

//动态添加set方法
SEL sel = NSSelectorFromString([NSString stringWithFormat:@"set%@",keyPath.capitalizedString]);
class_addMethod(kvoClass,sel,(IMP)setValue,NULL);
```




#### KVC：key-value-Coding
两个方法：
*  -(id)valueForKey: ( NSString * ) key
*  -(void)setValue:(id)value forKey:(NSString * ) key
q1: KVC 是否会破坏面向对象编程思想？
会，因为可以通过KVC访问到私有变量
q2: 系统实现逻辑
* valueForKey：会判断是否存在对应的getter方法，如果不存在，会判断实例变量是否存在，如果存在，会直接获取实例变量的值，否则会调用当前实例的 valueUndefinedKey的方法，抛出NSUndefinedKeyException异常。
* setValue: forKey: 会判断是否有跟这个key相关的方法，如果不存在，会判断实例变量是否存在，如果存在，直接赋值，否则会调用setValue: ForUndefinedKey方法，会抛出NSUndefinedKeyException异常。

q1、通过kvc设置value能否生效?
能，因为KVC调用的setValue:forKey:这个方法，最终也会调用该类对应属性的set方法，而setter方法又正好被子类重写了，所以能够生效
q2、通过成员变量直接赋值value能否生效？
不能。需手动添加willChangeValueForKey和didChangeValueForKey方法才能生效。

#### 属性关键字
属性关键字分为哪几类？

* 读写权限：readWrite、 readOnly
* 原子性：atomic、nonatomic
* 引用计数：retain/strong 、assign/unSafe_unretaind、weak、copy

q1、atomic 所修饰的属性关键字可以保证赋值和获取的线程安全性。比如我们用atomic修饰了一个数组，那么对数组的获取和复制是可以保证线程安全的，但是如果我们对数组进行操作，比如说添加对象或移除对象，则无法保证线程安全的。

q2、asign和weak的区别： assign用于修饰基本数据类型，如int、bool等；assign修饰对象类型时，不改变引用计数，且对象被释放后，assign指针仍然指向原对象内存地址，不会自动释放，会产生野指针。 weak只用来修饰对象，不改变对象的引用计数、在所修饰的对象释放后，weak指针会自动置为nil。共同点就是都不会改变被修饰对象的引用计数。

q3、weak关键字所修饰的对象被释放后，为什么会被置为nil呢？

q4、浅拷贝和深拷贝的区别：
浅拷贝就是对内存地址的复制，让目标对象指针和原对象指向同一片内存空间。
深拷贝就是会将内存空间拷贝一份。目标对象指针和原对象指针指向两片内容相同的内存空间
1、深拷贝会产生新的内存空间分配，浅拷贝不产生新的内存空间；
2、深拷贝不会改变引用计数，浅拷贝会影响被拷贝对象的引用计数； 

q5：copy & mutableCopy
1、对可变对象进行copy，产生不可变对象，是深拷贝；
2、对可变对象进行mutableCopy。产生可变对象，是深拷贝；
3、对不可变对象进行copy，产生不可变对象，是浅拷贝；
4、对不可变对象进行mutableCopy，产生可变对象，是深拷贝；

