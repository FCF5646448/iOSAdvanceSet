#### Mach-O的生成过程：

以下面C语言代码为例：

```
#include <stdio.h>
int main(int argc, char *argv[])
{
	printf("hello World!\n");
	return 0;
}
```

* **预编译**：$ xcrun clang -E helloworld.c

  预编译主要包括:

  * 头文件的导入：#include<xxx.h>。这种导入是直接将xxx.h的内容插入到#include的位置。又因为xxx.h又包含其他文件，所以这又是一个递归的过程。
  * 宏的替换：#define xx
  * 预编译指令的处理：#if #else
  * 注释的处理等。

* **编译**：$ xcrun clang -S helloworld.c -o helloworld.s

  生成汇编代码文件 helloworld.s

  其实生成汇编的过程内部会先细分为以下几步：

  * 词法分析：$xcrun clang -fmodules -fsyntax-only -Xclang -dump-tokens helloworld.c

  * 语法分析： $xcrun clang -fmodules -fsyntax-only -Xclang -ast-dump helloworld.c

  * 生成LLVM IR：$xcrun clang -S -emit-llvm helloworld.c -o helloworld.ll

  查看汇编文件代码：
  ```
  /// 前4行是汇编指令，不是汇编代码。.section 表示接下来会执行哪个段
  	.section	__TEXT,__text,regular,pure_instructions	## 表示会进入或使用一段纯指令的TEXT段
  	.build_version macos, 10, 14	sdk_version 10, 14	## 编译的版本
  	.globl	_main                   ## -- Begin function main 系统调用入口
  	.p2align	4, 0x90		## 代码对齐方式，这里按照 16(2^4) 字节对齐，如果需要的话，用0x90补齐。		
  _main:                                  ## @main
  	.cfi_startproc												## 函数开始，与后面的.cfi_endproc匹配。cfi表示的是函数调用帧。
  ## %bb.0:
  	pushq	%rbp	## rbp寄存器（也叫基础指针寄存器），主要用来存储栈帧地址，以便当前函数执行完成后再回到前面函数的调用位置（也就是后面的pop操作）。
  	.cfi_def_cfa_offset 16
  	.cfi_offset %rbp, -16
  	movq	%rsp, %rbp
  	.cfi_def_cfa_register %rbp
  	subq	$32, %rsp
  	movl	$0, -4(%rbp)
  	movl	%edi, -8(%rbp)
  	movq	%rsi, -16(%rbp)
  	leaq	L_.str(%rip), %rdi
  	movb	$0, %al
  	callq	_printf
  	xorl	%ecx, %ecx
  	movl	%eax, -20(%rbp)         ## 4-byte Spill
  	movl	%ecx, %eax
  	addq	$32, %rsp
  	popq	%rbp
  	retq
  	.cfi_endproc
                                          ## -- End function
  	.section	__TEXT,__cstring,cstring_literals	## 表示会进入或使用一段纯文本的TEXT段
  L_.str:                                 ## @.str 获取字符串指针
  	.asciz	"hello World!\n"
  
  .subsections_via_symbols
  ```

* **汇编器**：将汇编代码转出机器码

* **链接器**：主要是将多个目标文件以及使用到的各种库文件连接起来。（比如这里使用到了printf函数，则需要将stdio.h文件连接起来）

  ```
  callq _printf
  ```

  printf()是libc库中的函数。_ printf 是一个符号。链接器的作用就是读取所有目标文件(helloworld.s)和库(libc)，通过符号_printf找到printf()函数地址，然后将他们编码进可执行文件a.out中。

  * **符号表与链接**：

    ```
    /// 查看helloworld.o目标文件的内容
    $ xcrun nm -nm helloworld.o
                     (undefined) external _OBJC_CLASS_$_Foo
    0000000000000000 (__TEXT,__text) external _main
                     (undefined) external _objc_autoreleasePoolPop
                     (undefined) external _objc_autoreleasePoolPush
                     (undefined) external _objc_msgSend
                     (undefined) external _objc_msgSend_fixup
    0000000000000088 (__TEXT,__objc_methname) non-external L_OBJC_METH_VAR_NAME_
    000000000000008e (__TEXT,__objc_methname) non-external L_OBJC_METH_VAR_NAME_1
    0000000000000093 (__TEXT,__objc_methname) non-external L_OBJC_METH_VAR_NAME_2
    00000000000000a0 (__DATA,__objc_msgrefs) weak private external l_objc_msgSend_fixup_alloc
    00000000000000e8 (__TEXT,__eh_frame) non-external EH_frame0
    0000000000000100 (__TEXT,__eh_frame) external _main.eh
    ```

    

    在上面编译结果的代码中，主要就是对指针（变量指针、函数指针、参数指针等）的操作。而对于函数、全局变量、类等，都是通过符号的形式来定义和表示的。

    在从目标文件到可执行文件的生成过程中，会生成一个符号表。比如_ main 符号表示main函数、_ OBJC _ CLASS _ $ _ XX表示XX类、_ NSLog 表示NSLog函数等。然后汇编代码直接使用这些符号进行表示。所以在库运行的编译完成会在包里看到不同库（包括当前可执行文件）的Dsym文件，它就是符号表。

    在符号的表示过程中，如果是当前文件中未定义的函数（也就是说调用了其他的函数），则会使用一个**undefined**关键字表示。当链接器对目标文件与动态库进行连接时，它将尝试定位所有undefined符号，并且记录源文件和路径。(当然了，这些符号还都是undefined)

    ```
    // 目标文件中的内容多了from xx的标识
    $ xcrun nm -nm a.out 
                     (undefined) external _NSFullUserName (from Foundation)
                     (undefined) external _NSLog (from Foundation)
                     (undefined) external _OBJC_CLASS_$_NSObject (from CoreFoundation)
                     (undefined) external _OBJC_METACLASS_$_NSObject (from CoreFoundation)
                     (undefined) external ___CFConstantStringClassReference (from CoreFoundation)
                     (undefined) external __objc_empty_cache (from libobjc)
                     (undefined) external __objc_empty_vtable (from libobjc)
                     (undefined) external _objc_autoreleasePoolPop (from libobjc)
                     (undefined) external _objc_autoreleasePoolPush (from libobjc)
                     (undefined) external _objc_msgSend (from libobjc)
                     (undefined) external _objc_msgSend_fixup (from libobjc)
                     (undefined) external dyld_stub_binder (from libSystem)
    0000000100000000 (__TEXT,__text) [referenced dynamically] external __mh_execute_header
    0000000100000e50 (__TEXT,__text) external _main
    0000000100000ed0 (__TEXT,__text) non-external -[Foo run]
    0000000100001128 (__DATA,__objc_data) external _OBJC_METACLASS_$_Foo
    0000000100001150 (__DATA,__objc_data) external _OBJC_CLASS_$_Foo
    ```

* 直接生成可执行文件：$xcrun clang helloworld.c
  会得到一个默认的a.out文件

#### Mach-O 文件组成
* **Section**：一个可执行文件包含多个段(Section)。mach-o文件不同的部分会加载进不同的Section中，然后每Section再转换进某个Segment中。
可以使用size工具查看a.out内容
```
	$ xcrun size -x -l -m a.out
	/// 得到结果：
	Segment __PAGEZERO: 0x100000000 (vmaddr 0x0 fileoff 0)
	Segment __TEXT: 0x1000 (vmaddr 0x100000000 fileoff 0)
		Section __text: 0x31 (addr 0x100000f50 offset 3920)
		Section __stubs: 0x6 (addr 0x100000f82 offset 3970)
		Section __stub_helper: 0x1a (addr 0x100000f88 offset 3976)
		Section __cstring: 0xe (addr 0x100000fa2 offset 4002)
		Section __unwind_info: 0x48 (addr 0x100000fb0 offset 4016)
		total 0xa7
	Segment __DATA: 0x1000 (vmaddr 0x100001000 fileoff 4096)
		Section __nl_symbol_ptr: 0x8 (addr 0x100001000 offset 4096)
		Section __got: 0x8 (addr 0x100001008 offset 4104)
		Section __la_symbol_ptr: 0x8 (addr 0x100001010 offset 4112)
		total 0x18
	Segment __LINKEDIT: 0x1000 (vmaddr 0x100002000 fileoff 8192)
	total 0x100003000
```
* 为什么需要转换成Segment和Section？
  主要原因就是跟操作系统的虚拟内存地址映射有关，可以查看下一小节加载过程。总之就是**虚拟内存映射的时候是以Page为单元进行映射的。而Mach-O文件中的Segment也是以page为基本单位。所以这样就能在程序启动的时候更高效地加载Mach-O文件。其次每个Segment里的内容的读写权限是一样的，也更方便加载和使用。比如_TEXT 是只读的可执行的，_DATA是可读写不可执行的**。而Section则是用来表示相同权限的Segment中，不同的可执行部分。（相当于Segment利于虚拟内存、进程层面的使用，section则更利于于可执行文件内部的调用）

segment和section只是Mach-O的基础组成部分。为了更高效地加载，Mach-O的文件结构依次为：Header、Load Commands、Data

* Header：
  主要用于描述Mach-O的类型、加载命令数量、大小、目标架构。

* Load Commands:
  加载命令。其实就是上面可执行文件中.section的命令的集合。主要包括命令（比如链接、重定位等）、数据(_TEXT、_DATA)、加载方式。
  当然了，命令也是以Segment的方式分开的，因为命令也是需要加载进内存当中的。

  这些命令正好表示了文件的逻辑结构以及在虚拟内存中的布局。以指导系统如何装载当前可执行文件。

* DATA：
  DATA数据主要就是由Section组成的Segment的集合。主要的内容包括：主程序代码、函数调用方法名、C语言字符串、OC类名和系统Protocol名称、符号表、代码签名、已初始化数据、未初始化数据等。
  注意：每个Segment和Load Command的Segment是一一对应的。

#### Mach-O加载过程
* 虚拟内存：
	* 进程运行的时候，会被分配一块独立的虚拟内存地址。一是为了隔离各进程互不影响，二是为了使ARM更多地给当前优先级高的进程使用（比如前台APP）。
	* 为了更高效地使用内存，虚拟内存的映射方式是以page为单位进行的，虚拟内存和物理内存并不一定是一对一的关系，可能存在有的逻辑地址不对应物理内存地址、也可能多个逻辑地址对应同一块物理内存地址。所以：
		* 1、当某个逻辑地址没有对应的物理内存地址时，内核会中断当前线程以执行对应策略；（这就是传说中的 Page fault）
		* 2、多个逻辑地址映射到同一块物理内存地址，则允许多个进程共享这一块物理内存地址；(这就是进程间通信的实现方式)
		* 3、文件读取的时候。以page大小的内存进行映射，而无需一次性全部加装进来，实现了文件的懒加载，且说明可以多个进程共享。（注意：这里特意只说明是文件，也就是TEXT Segment。而DATA部分，是使用Copy-On-Write的方式）。
  * Page的状态：
  	* Nonresident：表示Page是否被映射到内存里了。
  	* Resident and clean：这类文件一般是表示只读文件，比如系统framework、可执行文件、通过mmap方式读取的文件等。这类文件会在物理内存紧张时被释放出去，等需要用到时再重新加载进来。
  	* Resident and dirty：凡是非clean的都是dirty的。它们表示Page在磁盘中没有对应的文件。比如通过alloc在堆上创建的内存空间、已解压的图片等。只有通过手动回收或进程被杀死的时候才能回收。

* 装载：
	* 安全性：
		* ASLR：是一个偏移值，镜像加载的起始地址是随机的
		* 代码签名：Mach-O文件中每一个Segment都有一个单独的加密散列值，可以用来校验是否被篡改。
	* dyld：动态链接器，用来加载所有依赖的外部库。对于一些系统的库，这个过程也会使用到动态库缓存等方式来进行优化。(我的理解是这些动态库实际上也是根据内容作为不同的Segment插入到当前进程中的)
	* 加载流程：
		* 1、内核将可执行文件加载进内存。加载开始会使用ASLR，以保证每一次都是不同的偏移地址。这里会使用一个函数叫exec()
		* 2、加载的过程中实际上就是根据Mach-O文件中的Load Commands依次进行的。
		* 3、当执行到有加载外部库的时候，就会使用dyld递归地将外部库映射到内存中（当然这里会使用动态库缓存机制，优化加载速度）。
		* 4、因为dyld是在执行过程中动态加载进来的，所以每次加载完，需要进行一些指针的调整。主要包括Rebase(调整镜像内指针便宜)和Binding(设置指向镜像外部指针内容)。
		* 5、ObjC setup。大多数OC的setup在reabse和binding阶段也完成了。这一步主要就是执行：注册所有class、将Category插入方法列表等；
		* 6、Initializer阶段。主要包括为C++动态对象创建初始化器，调用+load。
		* 7、执行程序入口main()函数。

#### 启动优化
	https://zhiyongzou.github.io/2018/03/26/iOS%20App%E5%90%AF%E5%8A%A8%E4%BC%98%E5%8C%96/
#### 内存优化
	https://guiyongdong.github.io/2018/10/16/%E3%80%90%E8%BD%AC%E3%80%91iOS-Memory-Deep-Dive/

#### 参考(感谢)
[Mach-O可执行文件](https://objccn.io/issue-6-3/)
[iOS Memory Deep Dive](https://guiyongdong.github.io/2018/10/16/%E3%80%90%E8%BD%AC%E3%80%91iOS-Memory-Deep-Dive/)
[iOS App启动优化](https://zhiyongzou.github.io/2018/03/26/iOS%20App%E5%90%AF%E5%8A%A8%E4%BC%98%E5%8C%96/)
[iOS Mach-O 博客园](https://www.cnblogs.com/dins/p/ios-macho.html)
[Mach-O文件介绍及dyld加载](https://www.jianshu.com/p/7ad7b3ba7985)
[Mach-O 装载与库](https://zhuanlan.zhihu.com/p/42951190)