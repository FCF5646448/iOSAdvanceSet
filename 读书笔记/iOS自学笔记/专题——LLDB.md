---
title: iOS-技能知识小集
date: 2020-10-19 17:36:48
tags: knoeledgePoints
categories: iOS进阶
description:  总结了iOS开发过程中的的动态调试相关的知识点
---


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










