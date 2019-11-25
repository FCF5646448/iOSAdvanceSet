#### 语言

* 1、为什么说OC是一门动态语言？（消息转发和函数调用的区别）

* 2、





#### category
运行期决议
1、使用场景和作用？

2、是否可以添加成员变量？是否可以添加属性？

3、

#### associalted
1、关联对象的如何存储？

2、关联对象使用场景？


#### 扩展
1、Extension的作用是什么
编译时决议，声明私有属性、私有方法、私有成员变量。一般和宿主的.m文件一起

#### 代理
1、为啥苹果要在有delegate的情况下还加入了block？
代理和block都是处理一对一的通信。
block相对代理来说更加简洁紧凑。但是block的运行成本更高，如果block从栈变成了堆，需要对捕获的数据也拷贝一份，而delegate只保存了一个对象指针。
**使用场景**：
如果一个回调是不定期或多次出发的（更注重过程），那么使用delegate会更合适，比如tableviewdelegate。
如果使用回调是一次性或者回调方法和执行上下文连续在一起的（更注重结果），那么就更适合使用block，比如UIView animation.

#### 通知
一对多的通信
1、通知的底层实现？
通知中心Center维护着一个散列表Hash表。HashMap是以NotificationName为键值，所有ObserverModel组成的链表为Value。ObserverModel的成员变量包括了Observer、SEL、object等等。


#### KVO
1、KVO的底层是怎么实现的？



#### KVC 
1、KVC的底层实现


#### 属性关键字
* 1、属性的实质是什么？包含哪几个部分，属性默认的关键字有哪些？@dynamic和@synthesize关键字是用来做什么的？

* 2、weak和assign的区别？weak的实现原理是什么？
* 3、 _ weak  、 _  strong   、_  block 比较？ 

* 4、atomic和 nonatomic的区别？

* 5、为啥String一定要使用copy ? 什么是深拷贝和浅拷贝？

* 6、block为啥要使用copy？不使用会有什么问题？
* 7、







