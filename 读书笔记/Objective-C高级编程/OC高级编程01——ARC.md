##### 什么是ARC？
ARC是自动内存管理技术，它通过LLVM编译器与runtime协作，在合适的时机给代码插入retain、release等方法，实现自动引用计数的管理。

##### 怎样进行管理？
ARC通过所有权修饰符来对引用计数进行管理。
* __ strong ： 它是id类型和对象类型默认的修饰符。使用 _ _ strong 修饰的对象，引用计数+1，初始化时引用计数为1。
```OC
//首先，所有的变量都遵循作用域规则，在超出作用域范围后，变量会被回收释放。
//eg1、默认修饰符
{
    id obj = [[NSObject alloc] init];
    /*
    这里实际上就是:
    id __strong obj = [[NSObject alloc] init];
    */
}
	/*
	当程序运行到这里，obj变量超出作用域被释放，同时释放obj持有的NSObject对象；
	NSObject对象的所有者不存在，因此遭到废弃；
	*/

//eg2、
@interface Test:NSObject {
    id __strong obj_;
}
-(void)setObjc:(id __strong)obj;
@end
@implementation Test
-(id)init{
    self = [super init];
    return self;
}
-(void)setObjc:(id __strong)obj {
    obj_ = obj;
}
@end
{
    id _strong test = [[Test alloc] init];
    /*
    test持有Test对象的强引用，Test对象引用计数为1
    */
    [test setObjc:[[NSObject alloc] init]];
    /*
    调用set函数后，Test对象的obj_成员变量持有NSObject对象的强引用，NSObject对象引用计数为1；
    */
}	
	/*
	当程序走到这里，test变量超出了作用域被释放，同时释放了持有的Test对象。
	Test对象的所有者不存在了，所以Test对象惨遭废弃；
	Test对象废弃的同时，会释放掉obj_成员变量；
	obj_成员变量被释放的同时也就释放了持有的NSObject对象。
	NSObject对象的所有者不存在了，所以NSObject对象惨遭废弃。
	*/
```

* _ _ weak:
	__weak修饰的变量会被立即释放。赋值给 _ _ weak 的对象，引用计数不会变。在对象被释放后，_ _weak 变量会自动失效且被置为nil，这样不会产生垂悬指针。
```oc
//eg1
{
	id __weak objc = [[NSObject alloc] init];
    /*
    代码如果仅是这样的话，那么NSObject对象刚初始化就会被释放；
    实际上，编译器也会给出警告的。
    */
}	
//eg2
{
    id __strong objc =[[NSObject alloc] init];
    id __weak objc1 = objc;
    /*
    实际上，__weak 的变量都是这样使用的；
    NSObject对象初始化后都默认赋值给__strong的变量；
    之后再赋值给__weak的变量。
    */
}
	/*
	超出作用域后，objc变量被释放，同时释放了持有的NSObject对象；
	而weak本身就不强引用对象，况且已超出作用域，所以objc1变量也会被置为nil
	NSObject对象的所有者不在了，所以NSObject对象惨遭废弃；
	*/
```
* __ unsafe_unretained ：
	 __weak是iOS5之后出来的，在iOS5之前使用__unsafe_unretained.其和__weak的作用是一样的，只是正如其名，它是unsafe的，unsafe的地方在于其修饰的变量所持有的对象释放后，其修饰的变量不会自动置为nil，导致垂悬指针。


```OC
id _unsafe_unretained obj1 = nil;
{
    id __strong obj = [[NSObject alloc] init];
    obj1 = obj;
}
	/*
	超出作用域后，objc变量被释放，同时释放了持有的NSObject对象；
	NSObject对象的所有者不在了，所以NSObject对象惨遭废弃；
	obj1所持有的对象释放了，但是obj1变量不会被置为nil，会产生垂悬指针！
	*/
```
* __ autorelease ：


##### 