##### 什么是ARC？
ARC是自动内存管理技术，它通过LLVM编译器与runtime协作，在合适的时机给代码插入retain、release等方法，实现自动引用计数的管理。

##### 具体实现细节披露
* 1、调用alloc或retain方法时，引用计数+1，调用release时引用计数-1，当引用计数为0时，调用dealloc方法废弃对象。(提出疑问：id _ _ weak objc = [[NSObject alloc] init]; NSObject对象引用计数为1，为什么会立即释放？)；————出自GunStep
* 2、苹果内部采用散列表来管理引用计数，步骤是，先通过obj获取到对应的table，然后通过Hash函数获取引用计数:count = CFBasicHashGetCountOfKey（table,obj）;
* 3、AutoreleasePool由主循环的NSRunLoop进行生成、持有、废弃。
* 4、init方法只是对alloc方法返回值得对象进行初始化处理并返回该对象；


有一个大胆的想法，ARC时，所有权修饰符不会直接对引用计数有影响！

##### 怎样进行管理？
ARC的所有权声明：
* _ _ strong ： 它是id类型和对象类型变量或属性默认的修饰符。使用 _ _ strong 修饰的变量或属性强引用该对象，强引用会持有对象实例。
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

* __weak：
	使用 _ _ weak修饰的变量对所持有的对象进行弱引用。弱引用不持有对象实例。 在所持有对象被废弃后，_ _weak 变量会自动失效且被置为nil，这样不会产生垂悬指针。     
	会被立即释放。赋值给 _ _ weak 的对象，引用计数不会变。
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
	底层实现：使用__weak修饰的变量会调用objc_initWeak进行初始化，然后将变量的地址注册到weak表中(weak表示一个hash表)。释放对象时，当引用计数为0会调用dealloc方法，dealloc会查看weak表记录，将所有__weak修饰的变量地址赋值为nil，然后从weak表中删除记录。

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
	在ARC中，@autoreleasePool{}用来替换NSAutoreleasePool类；用附有__autorelease修饰符的变量替代autorelease方法。
	autorelease是在一次runloop迭代时会查找
	在有大量对象初始化时，使用autorelease避免内存过高
```OC
	for(int i =0; i<100000; i++) {
		@autoreleasepool {
            NSMutableArray * arr = [NSMutableArray array];
            ...
		};
	}
```
被__weak 修饰的变量在使用时会被临时注册到autoreleasepool中!!（这一点是第一次听说，需要验证可信度)
```OC
	@autoreleasePool {
        id __strong obj = [[NSObject alloc] init];
        _objc_autoreleasePoolPrint();
        id __weak o = obj;
        NSLog(@"before using __weak:retain count = %d", _objc_rootRetainCount(obj)); //结果是1
        [0 class];
        NSLog(@"after using __weak:retain count = %d", _objc_rootRetainCount(obj));//结果是2
        _objc_autoreleasePoolPrint();
	}
```






#####  总结：
总体来说，这个章节给我的感觉就是混乱，看的我很纠结。个人总体概括来说，主要是分析了ARC下，strong、weak、Autorelease、unsafe_unretained等具体底层实现。其实只讲解了内存管理中weak表及side table的问题！对新的TagPoint、NONPOINTER_ISA没有任何涉及。不过也算是对，内存管理方面的巩固吧，让我对引用计数有了更清晰的认识！

