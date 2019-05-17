---
title: iOS内容管理
date: 2018-05-01 23:18:03
tags: memory manager
categories: iOS进阶
description:  iOS内存管理使用的是ARC自动内存管理规则，通过引用计数来决定是否释放对象。而引用计数的存储则是用过不同的解决方案，有些对象如果支持使用TaggedPointer，则会直接将其指针值作为引用计数值返回；如果是在64位架构下，那么一些对象会使用isa指针的一部分空间来存储它的引用计数，否则runtime会使用一张散列表来管理引用计数。
---

#### 内存布局
内存地址从低到高，依次是：
*  代码区：
*  已初始化数据区：(包括已初始化全局变量、已初始化静态变量、字符串常量)
*  未初始化数据区：(未初始化全局变量、未初始化静态变量)
*  堆区：由低地址向高地址扩展，我们创建的对象以及block经过copy之后都会被转移到堆上，比如经过alloc分配的对象。堆地址需要程序员代码操作
*  栈区：由高地址向低地址扩展，我们定义的函数(包括参数和局部变量)都是存放在栈里。栈的内存是自动释放的，无需程序员操作

#### ARC & MRC
MRC是手动内存管理，ARC是自动内存管理，它通过LLVM编译器和runtime协作在合适的时机给代码添加retain和release等代码，实现自动引用计数的管理。ARC无法显示调用retain和release等函数。

#### 内存管理方案
**TaggedPointer**：对于一些小对象，比如NSNumber和NSDate。它实际上采用的是TaggedPointer的管理方式进行内存管理的，它是对象指针实际上不执行任何内存地址，而是直接将值存储在了指针本身里，该指针就被拆分成两部分，一部分是直接保存数据，另一部分是作为特殊标记。
**NONPOINTER_ISA**：在64位架构下，一个isa指针是由64位比特位组成。而实际上存储改对象所属类对象地址只需要用到大概33位，所以剩下的位数就可以用来存储其他的信息。比如第一位存储的是当前指针是否是一个纯isa指针，如果是0则表示是只存储了所属类对象的内存地址，如果是1则表示不是一个纯isa指针，也就是这里的非指针类型的ISA，那NONPOINTER_ISA第位2则存储了当前对象是否有关联对象，第3位表示是否是否使用ARC，接下来的33位表示所属对象的内存地址，接着是表示是否完成初始化的magic，之后1位表示该对象是否有弱引用指针，接着1位表示是否正在执行deallocing，再下1位则表示引用计数是否过大无法存储在isa指针，剩下的几位则用来存储实际的引用计数。也就是说当引用计数小于某个值(大概是10)的时候，并不需要使用外挂散列表存储引用计数相关信息，若超过了这个值，则需要使用。
**散列表：SideTables**：它是由多个散列表组成的SideTables。每个散列表下包含了一个自旋锁、一个引用计数表、一个弱引用表。
q1：为什么使用多个sidetable
因为操作引用计数需要加锁，这样就存在效率问题，而分割成多个sidetable，就可以并行操作，提高访问效率。
q2：怎么实现快速分流，也就是说如何快速定位到是属于哪一张sidetable？
sidetable的本质是一个散列表，那么它就是通过对象指针作为key值，经过hash计算定位到相对的sidetable的，比如用过key值对sidetables的个数取余，这样就增加了访问效率，无需遍历。

#### 内存数据结构
**自旋锁**：它是一个“忙等”的锁，也就是说在当前资源被某个线程占用的时候，其他的线程会一直试探该锁有没有解锁，而像信号量，则是会在获取不到资源的时候进行休眠，等资源被释放后，则再被唤醒。
**引用计数表**：引用计数表也是一个hash表，它是通过hash函数插入和获取引用计数，提高访问效率。hash表里的每个元素是一个unsigned long类型的size_t。它也是由64位比特位组成，其中第一位是表示是否有弱引用，第二位表示是否正在执行dealloc函数。剩下的则是表示引用计数的值，所以计数的时候需要位移2位，也就是加减4。
**弱引用表**：实际上也是一个hash表，它存储的是一个weak_entry_t的结构体数组，它里面的每个对象存储的都是一个弱引用指针。

#### 引用计数
alloc ：
q1:通过alloc生成的对象，其实并没有设置引用计数为1。但是获取它的引用计数的时候确实是1，为什么。
retain：
q1：我们在进行retain操作的时候，系统是怎么查找其对于的引用计数的呢？
是经过两次hash查找，然后进行+1操作（实际上是位移操作）。
release：
同样是经过两次hash算法，获取到引用计数值，然后进行-1操作。
retainCount：
**查找引用计数时，会通过一个初始化为1的局部变量 ➕ 上面各方法中查找到的引用计数值。所以说上面说的isa或散列表等存储的引用计数值实际上就是引用计数的值减一**。而这也说明了为什么执行alloc操作时，没有设置引用计数，但是查找到的retainCount仍然为1的原因。
dealloc:
执行dealloc时，判断是否可以释放的条件包括：是否使用nonpointer_isa、是否有弱引用指针、是否有关联对象、是否使用ARC、是否使用sidetable。如果这些条件都为NO的时候，就可以直接使用c函数free直接释放，否则则要调用objc_dispose()进行进一步清理。
而objc_dispose则会一步步 移除对关联对象、将指向该对象的弱引用指针置为nil，将当前对象在引用计数表的数据清除掉等操作。(这里解决了两个面试题:1、对象在释放的时候，是否有必要移除掉关联对象；2、weak修饰的对象是怎么讲指针置为nil的。答案就是在dealloc内部实现的时候有做这些操作)

#### 弱引用  _ weak
q1：系统是怎样把一个weak变量添加到它对应的弱引用表中的。
一个被声明为 _ weak 的对象指针，经过编译器编译，会调用一个objc_initWeak函数，之后会调用weak_register_no_lock()函数进行弱引用变量的添加，具体添加的位置是通过hash算法进行位置查找的，如果查找的对应位置中已经有了当前对象对应的弱引用数组，则把当前变量添加进弱引用数组，如果没有，则重新创建一个弱引用数组。
q2：当一个对象被释放之后，weak变量是怎么被清理的。
会被置为nil。当对象执行dealloc的时候会调用弱引用清除相关函数，在函数内部会通过弱引用指针找到弱引用数组，然后遍历所有的弱引用指针，分别置为nil。


#### 自动释放池
AutoreleasePool的实现原理：
AutoreleasePool为何可以嵌套使用：

首先编译器会将@autoreleasepool{}括起来的代码改写成:
```oc
void * ctx = objc_autoreleasePoolPush();
{}中的代码
objc_autoreleasePoolPop(ctx);
```
objc_autoreleasePoolPush函数内部会调用AutoreleasePoolPage的push函数，objc_autoreleasePoolPop(ctx)也是调用AutoreleasePoolPage的pop(ctx)函数。一次pop操作是一次批量的pop操作，也就是在push的时候，会将{}函数体里的所有对象添加进自动释放池中，当执行pop操作的时候，则会给每一个对象发送一次release操作。所以说是一次批量操作。

q1：什么是自动释放池？
是以栈为节点通过双向链表的形式组合而成的，是和线程一一对应的。因为AutoreleasePoolPage的数据结构包含一个AutoreleasePoolPage类型的parent指针和一个AutoreleasePoolPage类型的child指针，同时还包含一个pthread和一个id指针。


#### 循环引用
1、在日常开发者，是否遇到过循环引用问题，如何解决的。
一个页面有一个广告栏，需要在每一秒滚动一次，播放广告。假设广告栏是一个独立封装的对象。那么在广告栏对象里面就需要有一个定时器，做定时操作。这样就导致：VC页面持有广告栏对象，而广告栏对象持有NSTimer，而NSTimer的target又是广告栏对象。这样就导致了循环引用。而且NSTimer被分配之后，会被当前线程的RunLoop进行强引用。如果当前线程是主线程的话，所以即使公告栏对象弱引用NSTimer，在重复多次回调的定时器的情况下，无法在time的回调方法中执行invalidate和timer置为nil操作。所以仍然无法释放掉。这个时候就可以写一个中间对象：由NSTimer对中间对象强引用，中间对象对NSTimer和广告栏对象都进行弱引用。这样就可以正常释放了。
```oc
#import "NSTimer+WeakTimer.h"

@interface TimerWeakObjct : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;
- (void)fire:(NSTimer *)timer;
@end

@implementation TimerWeakObjct

- (void)fire:(NSTimer *)timer {
    if (self.target) {
        if ([self.target respondsToSelector:@selector(selector)]) {
            [self.target performSelector:self.selector withObject:timer.userInfo afterDelay:0];
        }
    }else{
        [self.timer invalidate];
    }
}
@end


@implementation NSTimer (WeakTimer)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                     target:(id)aTarget
                                   selector:(SEL)aSelector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)yesOrNo {
    
    TimerWeakObjct * obj = [[TimerWeakObjct alloc] init];
    obj.target = aTarget;
    obj.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:obj selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
    
    return obj.timer;
}
@end
```

#### Block
q1：什么是block
**block是将函数及其执行上下文封装起来的对象。**  block调用就是函数调用。

q2：截获变量：
block截获变量是根据被截获变量的类型进行区分的：
* 局部变量：基本数据类型、对象类型: 
对于基本数据类型的局部变量只截获其值，对于对象类型的局部变量，连同所有权修饰符一起截获,也就是直接操作对象。
* 局部静态变量：以指针形式进行截获。也就是说直接操作的指针，所以会被改变。
* 全局变量：不截获！所以操作就是直接使用全局变量本身。
* 全局静态变量：不截获！所以操作就是直接使用全局静态变量本身。

```oc
int global_var = 4;
static int static_global_var = 5;

- (void)block {
    int var = 6;
    __unsafe_unretained id unsafe_obj = nil;
    __strong id strong_obj = nil;
    static int static_var = 3;
    
    void (^Block)(void) = ^{
        NSLog(@"局部变量<基本数据类型> var %d",var);
        NSLog(@"局部变量<__unsafe_unretained var %@",unsafe_obj);
        NSLog(@"局部变量<__strong var %@",strong_obj);
        NSLog(@"静态变量： %d", static_var);
        NSLog(@"全局变量：%d",global_var);
        NSLog(@"静态全局变量：%d",static_global_var);
    };
    Block();
}
```

q3： _  block :
在什么场景下需要使用 _ block 修饰符。
一般情况下，对被截获变量进行赋值操作时需要加上 _ block 修饰符。但是全局变量、静态局部变量、静态全局变量不需要 _ block 进行修饰。
```oc
{
    NSMutableArray * arr = nil;
    void(^Block)(void) = ^{
	    //注意，这里就是赋值操作。
        __block arr = [NSMutableArray array];
    }
    Block();
}
```
如下面试题：通过 _ block 修饰的修饰之后，它实际上变成了一个结构体对象。所以依据block对对象的截获方式来看，m是会内内外不改变的。
```oc
{
    __block m = 6;
    int(^Block)(int) = ^int(num){
		return num * m
    };
    m = 4;
    NSLog(@"%d",Block(2)); //8
}
```
_ block 修饰的变量也会从栈复制到堆上，一是为了可以让多个block使用这个变量，二是为了更好管理，因为被 _ block修饰过的变量，会转换成 _ block 结构体， _ block 结构体中有一个forwarding指针，它始终指向结构体，所以在被block截获复制到堆上之后，无论在哪里修改该变量，都是对同一份变量进行操作。这里要注意，如果这个 _ block 修饰的变量未被某个block截获，那么它还是在栈上的生命周期。


q4:  block内存管理：
block分为以下三种
* 全局类型block：指没有用到任何外部变量，只用到全局变量、静态变量的block称作全局block，生命周期与应用程序等同。存放在已初始化数据区中；
进行copy操作，等于什么都没做。
* 栈类型上的block：只用到外部局部变量、成员属性变量，无强指针引用的block。
放到栈里；进copy操作，copy的结果是在堆上产生了一个block
* 堆上的block：有强指针引用或使用了copy关键字修饰的block。
放到堆里；进copy操作，copy的结果是会增加其引用计数。
```OC
NSObject * obj = [[NSObject alloc]init];
    NSLog(@"1.Block外 obj = %lu",(unsigned long)obj.retainCount);
    
    void (^myBlock)(void) = [^{
        NSLog(@"Block中 obj = %lu",(unsigned long)obj.retainCount);
    }copy];
    
    NSLog(@"2.Block外 obj = %lu",(unsigned long)obj.retainCount);
    myBlock();
   //[myBlock release];
    NSLog(@"3.Block外 obj = %lu",(unsigned long)obj.retainCount);

结果：
1.Block外 obj = 1
2.Block外 obj = 2
Block中 obj = 2
3.Block外 obj = 1
```

如果我们声明一个对象的成员变量是一个block，然后在栈上创建block，同时赋值给成员变量。如果成员变量block没有使用copy关键字，而是使用assign，那么当栈函数内存被释放的时候，继续访问这个block就会导致崩溃。那如果使用了copy关键字，那么在堆上就会产生一个一模一样的block。那么在MRC下，此时堆上的block就没有被释放掉，导致内存泄露。而被copy关键字进行修饰后的block，无论在哪对block进行访问，其实都是通过 _ forwarding 指针访问的堆上的block。

1、何时需要对block进行copy操作。
所以说如果一个block成员变量在栈上进行创建的话，那么就应该进行copy操作，避免block跟随栈函数被释放。

q5: block循环引用
1、自循环引用：
```OC
{
    _arr = [NSMutableArray array];
    _block = ^NSString *(NSString *name){
        return [NSString stringWithFormat:@“%@”，_arr[0]];
    };
    _block(@"hello");
}
```
block截获会连同属性关键字一起截获，所以 _ arr 应该是一个 _ strong类型，所以被截获到block里面后依然是 _ strong类型，所以这里就变成了自循环引用。解决方案就是改变block截获的 _ arr 的属性关键字，使用一个weak：
```OC
	__weak typeof(NSMutableArray *) weakArr = _arr;
    ...
    return [NSString stringWithFormat:@“%@”，weakArr[0]];
```
_ block 修饰符 引起的循环引用：
在MRC下，这段代码没有任何问题，但是在ARC下会产生循环引用，引起内存泄露。
```OC
{
    __block ClassSelf * blockself = selfl;
    _block = ^int (int num){
        return num * blockself.var;
    }
	_block(3);
}
```









