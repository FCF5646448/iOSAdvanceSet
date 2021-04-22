#### Mach-O的生成过程：

以下C语言代码为例：

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
* **链接器**：主要解决目标文件和库文件之间的链接。（感觉类似于将地址符号添加一个重定向地址，应该主要是调用了其他库的函数的符号绑定）
	
	```
		callq _printf
	```
	
	printf()是libc库中的函数。_printf是一个符号。链接器的作用就是读取所有目标文件(helloworld.s)和库(libc)，通过符号_printf找到printf()函数地址，然后将他们编码进可执行文件a.out中。

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
主要用于描述Mach-O的类型、加载命令数量和大小。

* Load Commands:
加载命令。其实就是上面可执行文件中.section的命令的集合。主要包括命令（比如链接、重定位等）、数据(_TEXT、_DATA)、加载方式。
当然了，命令也是以Segment的方式分开的，因为命令也是需要加载进内存当中的。

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

#### 参考
[Mach-O可执行文件](https://objccn.io/issue-6-3/)
[iOS Memory Deep Dive](https://guiyongdong.github.io/2018/10/16/%E3%80%90%E8%BD%AC%E3%80%91iOS-Memory-Deep-Dive/)
[Mach-O可执行文件](https://objccn.io/issue-6-3/)
[iOS App启动优化](https://zhiyongzou.github.io/2018/03/26/iOS%20App%E5%90%AF%E5%8A%A8%E4%BC%98%E5%8C%96/)
[iOS Mach-O 博客园](https://www.cnblogs.com/dins/p/ios-macho.html)
[Mach-O文件介绍及dyld加载](https://www.jianshu.com/p/7ad7b3ba7985)