---
title: iOS-技能知识小集
date: 2020-10-19 17:36:48
tags: knoeledgePoints
categories: iOS进阶
description:  总结了iOS开发过程中的的底层文件、动态调试相关的知识点
---

### 底层文件

#### 动态库共享缓存 (dyld shared cache)
从iOS3.1开始，为了提高性能，绝大部分的系统动态库文件都打包存到了一个缓存文件中(dyld shared cache)。
动态库共享缓存有一个非常明显的好处就是节省内存。因为所有的mach-o文件都共享一个缓存，独立的描述文件就可能不再需要了，其次库也可能被压缩了。

* 动态库的加载
iOS中，使用**dyld程序**来加载动态库。
dyld程序的过程：先从内存缓存中查找动态库。如果内存中有缓存一份就不会重复加载。然后直接使用共享缓存里的动态库。

#### Mach-O
Mach-O是Mach object的缩写，是iOS上用于存储程序、库的标准格式。iOS的程序最终都是编译成Mach-O可执行文件。

##### Mach-O的文件类型
* MH_EXCUTE：可执行文件。
* MH-OBJCT: 目标文件(.o)、静态文件(.a)。//目标文件是编译过程中生成的一个中间文件，静态文件可以理解为是由多个目标文件组成的。
* MH_DYLB：动态库文件。包括后缀为.dylib、.framework的文件；
* MK_DYLINK：动态链接编辑器。其实就是指dyld程序文件。
* MK_DSYM：存储着二进制文件符号信息的文件，俗称dsym文件。通常用于分析APP的崩溃信息。
xcode 可以生成部分Mach-O类型的文件

##### 通用二进制文件
表示同时适用于多种架构的二进制文件。包含了多种不同架构的独立二进制文件。
可以使用lipo命令来拆分和组合不同架构的可执行文件。


##### dyld & Mach-O
dyld用于加载系统的动态库文件，也用于加载Mach-O类型的可执行文件。但是它只能加载Mach-O 的 EXECUTE、DYLIB、BUNDLE等类型文件。

##### Mach-O文件的基本结构
主要包括3个主要区域
* Header：文件类型、目标架构类型

* Raw commands：描述文件在虚拟内存中的逻辑结构、布局。(通常一个程序由多个内存段的信息组成，比如代码段、数据段。代码段是所有的函数，数据段是左右的全局数据等)。其中每个段文件都是有Load Commands描述的，它包含以下关键信息。
  * VM Address: Virtual Memory Address，表示**段**在虚拟内存中的地址

  * VM Size: Virtual Memory Size，表示**段**在虚拟内存中的大小

  * File Offset: 表示当前函数或变量在Mach-O文件中的位置

  * File Size:  表示当前函数或变量在Mach-O文件中占据的大小

  未使用ASLR的情况，也就是未加载进内存中的时候。_ PAGESIZE地址是为0的，只有当载入内存的时候，_ PAGESIZE才会被赋值。
  ```
  
  _PAGESIZE:	//类似一个安全区域，比如空指针就会被指向这里，实际使用不上。
  	VM Address: 0x0
  	VM Size: 0x100 000 000
  _TEXT:	//代码段
  	VM Address: 0x100 000 000
  	VM Size: 0x380C000
  _DATA:	//数据段
  	VM Address: 0x103 80C 000
  	VM Size: 0xD4C000
  _LINKDIT:	
  	VM Address: 0x104 558 000
  	VM Size: 0x2C8000
  ```

* Raw Data：每个段的详细数据。

**总结**：
通过Mach-O的基础结构，可以知道整个程序在编译成Mach-O文件后，被分成了Header、Raw Commands、Raw Data三个部分。最主要的代码、数据被分别存放在了Raw Data 中的_ Text代码段和 _ data数据段中，Raw Commands则是对每一个段的描述信息，主要包括每个段在文件中的大小和位置以及在虚拟内存中的大小和静态位置（未使用ASLR的地址）。另外，代码段的数据（其他段不可知）其实都是只读的，所以只要Mach-O文件一被编译完成，每个函数的地址都是固定的，这个地址叫做**静态函数地址**，与真正运行时的地址有所不同。


#### ASLR 
从Mach-O文件的分析可知，函数静态地址（刚编译完成的地址）是固定的。假如载入虚拟内存的地址不做任何处理，那么每个函数的地址是不是就非常容易被黑客知晓，而导致串改。所以**真实动态运行时的函数地址** = 静态函数地址 + 随机偏移值。这个随机偏移值就是**ASLR**。
**ASLR**：地址空间布局随机化。
ASLR使得函数等关键数据的地址难以预测，而达到防止攻击者直接攻击的一种方式。
所以：
运行时段基地址 = 静态模块基地址 + ASLR	(静态模块基地址编译就能获取)
运行时函数地址 = 静态函数地址 + ASLR	(静态函数地址编译就能获取)
运行时函数地址 = 运行时段基地址 + 函数偏移	(函数偏移是编译就能获取)
静态函数地址 = 运行时段基地址+ 函数偏移 - ASLR 	(函数偏移是编译就能获取)



#### dysm

dysm文件是一个符号表文件，它包含了一个16进制的函数地址映射信息。包括内存地址与函数名、文件名、行号等的映射表。

一般Xcode编译后，会产生一个.DSYM文件和一个.app文件。这两个文件有一个共同的UUID。

如果要解析一个Xcode符号化的crash log，则需要三个文件：.crash文件、.dsym文件、.app文件。

* .crash文件
	.crash文件注意包含了uuid、进程ID、程序运行时映射信息、崩溃堆栈信息。
	崩溃堆栈信息包含有调用顺序、库名、崩溃处地址、进程运行时起始地址、崩溃处距离进程起始位置的偏移量。其中**崩溃处地址 = 进程运行时起始地址 + 崩溃处距离进程起始位置的偏移量**。

获取到崩溃地址后，就可以使用dsym映射表找出app中对应的函数信息。


### 动态调试
#### Xcode调试原理
首先Mac上安装了LLDB，然后iPhone上运行APP。其次iPhone上有一个debugServer。顾名思义，debugServer就是一个调试服务器。当在xcode上打了断点的时候，就可以开启LLDB。输入LLDB指令，就相当于将LLDB的指令发送给iPhone上的debugServer，然后debugServer接收到指令后执行到APP里，APP获取到结果后反馈给debugServer，debugServer把结果反馈给LLDB。最终打印在xcode的控制台上。
* debugServer：
	 	如果手机没有进行过真机调试，其实iPhone上是没有这个文件的。一开始debugServer是存储在Xcode中的。当Xcode识别到手机设备时，Xcode会自动将这个程序安装到手机上。
#### LLDB 调试器
* help 指令
	help指令后面跟随某一个命令，用于打印该命令的使用方式
* breadpoint 指令
  breakpoint是断点的意思，也就意味着在xcode里的断点，都是通过LLDB终端指令来设置。断点可以包含命令断点、内存断点。

  ```
  //-n是name的意思。这条指令的意思是在test函数中设置一个断点。但是有个问题就是所有的类的test函数都会被加上断点，而不仅仅是当前类。得出的结果里有一个断点编号
  (lldb) breakpoint set -n test 
  
  //打断点在ViewController里的test:with:函数里。注意这里需要用双引号""括起来才能生效。得出的结果里有一个断点编号
  (lldb) breakpoint set -n "-[ViewController test:with:]"
  
  //将函数名包含"est"字符串的函数都打上断点。比如test函数以及大量的系统函数。(一般并不会这样直接用)
  (lldb) breakpoint set -r est 
  
  //这个用于在动态库的函数中打上断点，比如一些不可见的私有库，就可以使用这个进行调试
  (lldb) breakpoint set -s 动态库 -n 函数名 
  
  //打印所有断点，每个断点都含有一个断点编号
  (lldb) breakpoint list  
  
  //禁用断点
  (lldb) breakpoint disable 断点编号	
  
  //启用断点
  (lldb) breakpoint enable 断点编号
  
  //删除断点
  (lldb) breakpoint delete 断点编号   
  
  /*
  如果要执行一连串的lldb命令，那如何操作？？
  首先需要利用上面的方法获取到某一个断点的编号。然后再使用断点命令给该断点添加一系列命令，最后输入DONE结束.然后就可以输入c去继续执行，查看命令结果
  */
  (lldb) breakpoint set -n "-[ViewController test:with:]" //得到断点编号是2
  (lldb) breakpoint command add 2 //输入完成后，会提示输入debug commands
  > po self
  > p self.view.backgroundColor = [UIColor yellowColor]
  > DONE
  
  /*
  内存断点:就是某一块内存的断点。
  比如说一个int类型的age，我想查看age什么时候被修改了，被谁修改了。这个时候就可以使用内存断点。
  */
  //方法1
  (lldb) watchpoint set variable self->_age //注意这里不能使用self.age。命令结束后，也会产生断点编号，及与变量相关的信息。当执行到修改的地方，断点就会停留在成员变量的位置。此时使用命令bt查看堆栈信息，就能查看到修改变量age的函数信息。
  //方法2 
  (lldb) watchpoint set expression &self->_age 
  
  ```
* expression 指令 (p、call、po)
	expression指令用于动态添加代码。也可以用于打印某个对象。 p指令、print指令、call指令也可以做expression一样的事情。所以我们通常使用p指令进行动态添加代码或打印的操作。  
	```
	(lldb) expression self.view.backgroundColor = [UIColor yellowColor]
	(lldb) expresion self
	(lldb) p self.view.backgroundColor = [UIColor redColor];
	(lldb) call self.view.backgroundColor = [UIColor redColor];
	```
	但是expression也有其特有的作用。比如说打印命令。通常我们打印一个对象，可能只能打印该对象的内存地址，比如说一个数组，而没法像%@一样打印出数组里的元素。使用expression是可以打印出来的。这个指令和po指令是一样的。所以可以使用po代替
	```
	NSArray * array = @[@1,@2,@3];
	(lldb) expression array 	//这样就只能打印出类似0x000xxx等内容
	(lldb) expression -O -- array //这样就可以把具体元素打印出来。主要格式一定要 -- 。
	(lldb) po array //打印出来的效果和上一句指令是一样的
	```
* thread 指令 (bt)
	thread指令用于查看线程相关信息。
	```
	(lldb) thread backtrace 	//用于打印当前函数的调用堆栈。打印出来的结果有一个frame，它表示一帧。每一帧表示一个函数。
	(lldb) bt					//bt打印出来的结果与上一句一样。应该是backtrace的简写
	(lldb) thread return 		//用于返回当前函数，比如说想要提前return的情况，
	```
* frame 指针
	这个frame就是帧的意思。帧也就相当于一个函数。可以使用这个命令打印函数变量
	```
	(lldb) frame variable		//打印出当前函数的局部变量
	```
* 流程控制指令
	这个流程控制是指xcode上断点调试的几个控制流程，比如继续执行、单步执行、进入函数执行、跳出函数执行等。
	```
	(lldb) thread continue	// 程序继续执行，也可以使用c或continue，如果有断点会停留在在一个断点处
	(lldb) c
	(lldb) thread step-in	//单步执行，也可使用s或step，如果遇到函数，会跳入该函数内部再单步执行
	(lldb) s
	(lldb) thread step-over //单步执行，也可使用n或next，如果遇到函数，会将函数整体一步执行。
	(lldb) n
	(lldb) thread step-out	//也可使用finish，表示执行完当前函数的所有代码，返回上一个函数。
	(lldb) finish
	```
* 指令级别的命令
  上面的指令是源码级别的，这里的是指令级别的，指令级别就是汇编的调试。
  ```
  (lldb) ni		//汇编next执行
  (lldb) si		//汇编step执行
  ```

* 模块查找
	模块查找的命令都是image开头，也可以视为镜像查找。也就是在mach-o级别的命令
	```
	//列出所有镜像(或模块)：动态库、可执行文件等。
	(lldb) image list  	
	
	//查找某个类型的信息
	(lldb) image lookup -t NSInteger
	
	//查看某一个内存地址对应着源码哪一行。比如一个崩溃最终退到了APPDelegate。此时使用loopup -a 查看具体定位。最终会得到某一类的某一行。
	(lldb) image lookup -a 内存地址 
	
	//查找某个符号或函数的位置
	(lldb) image loopuk -n 函数名
	
	```










