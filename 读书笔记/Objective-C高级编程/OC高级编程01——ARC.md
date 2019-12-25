##### 什么是ARC？
ARC是自动内存管理技术，它通过LLVM编译器与runtime协作，在合适的时机给代码插入retain、release等方法，实现自动引用计数的管理。

##### 怎样进行管理？
ARC通过所有权修饰符来对引用计数进行管理。
* _ _ strong ：它是id类型和对象类型默认的修饰符。使用 _ _ strong 修饰的对象，引用计数+1，初始化时引用计数为1。
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
	
* _ _ weak ：
* _ _ unsafe_unretained ：
* _ _ autorelease ：

##### 