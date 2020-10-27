---
title: iOS-技能知识小集
date: 2020-8-11 20:36:48
tags: knoeledgePoints
categories: iOS进阶
description:  完整学习LLVM及OC的整个编译流程
---

### 编译连接
#### 编译型和解释型语言的区别：
* 编译型语言：先将代码经过编译器先编译成机器代码，然后再执行。所以每次修改完代码都得先编译，才能执行结果。优点就是**代码执行效率高**，缺点就是**编写调试周期长**。我们也称这种执行方式为“**AOT预先编译**”
* 解析型语言：不需要经过编译。执行的时候，通过一个解释器将代码解释成cpu可以执行的代码（实际上就相当于一边编译一边执行）。优点是**编写调试方便**，缺点是**执行效率不够高**。我们也称这种方式为“**JIT即时编译**”

#### 编译器
常见的编译器有GCC、LLVM等；
* LLVM是编译相关工具链的集合。它的整体架构分为：前端——> IR（优化器）——>后端。前端对应各种开发语言，IR 就是将编译后的汇编代码进行优化，后端就是对应机器架构。这样的模块化架构也让LLVM的扩展性做的非常好，如果需要支持一种新的编程语言，则只需要实现一种新的前端即可，如果要支持一种新的设备，则只需实现一个新的后端就好。

* Clang是LLVM的前端编译器，主要负责编译C、C++、OC等语言。前端的主要工作就是：预编译——词法分析——语法分析——语义分析生成中间代码IR；

Clang的优点：
	* 编译速度快；
	* 占用内存小；
	* 模块化设计；
	* 诊断信息可读性强；
	* 设计清晰简单，容易理解，易于扩展。


* OC采用Clang作为编译器前端，Swift采用Swift作为编译器前端，
  swift编译器则是先生成一种SIL的中间代码，然后由SIL生成IR。

#### OC的编译连接过程
对如下代码进行编译流程学习：
```
#include "stdio.h"
#define Age 40
int main(int argc, const char * argv[]) {
    int a = 10;
    int b = 20;
    int c = a + b + Age;
    return 0;
}

void test(int a, int b) {
    int c = a + b -4;
}
```
#### 0、查看编译过程
```
$clang -ccc-print-phases main.m

//得到如下结果
0: input, "main.m", objective-c
1: preprocessor, {0}, objective-c-cpp-output  	// preprocessor 预处理器；
2: compiler, {1}, ir	//compiler 编译 ，这里就生成ir了；
3: backend, {2}, assembler	//assembler 汇编；
4: assembler, {3}, object	// 汇编 
5: linker, {4}, image	// 连接
6: bind-arch, "x86_64", {5}, image 	//生成可执行文件
```


##### 1、**预编译**：主要是处理源代码中以“#”开头的预编译指令：
```
clang -E main.m //可以看到Age被40替换了
```
预编译主要作用：
* “#define”删除并展开对应宏定义；
* 处理所有预编译指令：#if、#ifdef、#else、#endif；
* "#include、#import"包含的文件递归插入此处；
* 删除所有注释；
* 添加行号和文件名标识；
##### 2、**编译**：就是把预编译得到的.i文件进行：词法分析、语法分析、静态分析、优化生成相应的汇编代码
* 词法分析：顾名思义就是对每个词进行分析，生成一个个token，主要是包括关键字、标识符变量名、字面量、特殊符号等。比如把变量名放到符号表等；
```
$clang -fmodules -E -Xclang -dump-tokens main.m

//得到如下结果
int 'int'	 [StartOfLine]	Loc=<main.m:13:1>
identifier 'main'	 [LeadingSpace]	Loc=<main.m:13:5>
l_paren '('		Loc=<main.m:13:9>
int 'int'		Loc=<main.m:13:10>
identifier 'argc'	 [LeadingSpace]	Loc=<main.m:13:14>
comma ','		Loc=<main.m:13:18>
const 'const'	 [LeadingSpace]	Loc=<main.m:13:20>
char 'char'	 [LeadingSpace]	Loc=<main.m:13:26>
star '*'	 [LeadingSpace]	Loc=<main.m:13:31>
identifier 'argv'	 [LeadingSpace]	Loc=<main.m:13:33>
l_square '['		Loc=<main.m:13:37>
r_square ']'		Loc=<main.m:13:38>
r_paren ')'		Loc=<main.m:13:39>
l_brace '{'	 [LeadingSpace]	Loc=<main.m:13:41>
int 'int'	 [StartOfLine] [LeadingSpace]	Loc=<main.m:15:5>
identifier 'a'	 [LeadingSpace]	Loc=<main.m:15:9>
...  
// 可以看到每一个词，包括标点符号，都生成了token。 
```
* 语法分析：生成抽象语法树AST。比如运算符优先级、括号匹配等；
```
$clang -fmodules -fsyntax-only -Xclang -ast-dump main.m

//得到下面的结果
...
|-FunctionDecl 0x7fcc2087bd78 <line:22:1, line:24:1> line:22:6 test 'void (int, int)'
| |-ParmVarDecl 0x7fcc2087bc08 <col:11, col:15> col:15 used a 'int'
| |-ParmVarDecl 0x7fcc2087bc80 <col:18, col:22> col:22 used b 'int'
| `-CompoundStmt 0x7fcc2087bf98 <col:25, line:24:1>
|   `-DeclStmt 0x7fcc2087bf80 <line:23:5, col:21>
|     `-VarDecl 0x7fcc2087be50 <col:5, col:20> col:9 c 'int' cinit
|       `-BinaryOperator 0x7fcc2087bf60 <col:13, col:20> 'int' '-'
|         |-BinaryOperator 0x7fcc2087bf20 <col:13, col:17> 'int' '+'
|         | |-ImplicitCastExpr 0x7fcc2087bef0 <col:13> 'int' <LValueToRValue>
|         | | `-DeclRefExpr 0x7fcc2087beb0 <col:13> 'int' lvalue ParmVar 0x7fcc2087bc08 'a' 'int'
|         | `-ImplicitCastExpr 0x7fcc2087bf08 <col:17> 'int' <LValueToRValue>
|         |   `-DeclRefExpr 0x7fcc2087bed0 <col:17> 'int' lvalue ParmVar 0x7fcc2087bc80 'b' 'int'
|         `-IntegerLiteral 0x7fcc2087bf40 <col:20> 'int' 4

/*这棵语法树是单独对test函数的语法树。可以看到几个关键字：
FunctionDecl：函数 声明
ParmVarDecl：参数 声明
CompoundStmt：函数体
DeclStmt：语句声明
Expr：表达式
BinaryOperator：操作符
IntegerLiteral：字面量
*/
```

* 中间语言LLVM IR生成：IR是中间代码，它有3种表示形式：
	* text：便于阅读的文本格式，类似汇编，扩展名 .ll
	```
	$clang -S -emit-llvm main.m
	
	//执行完成后会生成一个main.ll文件，打开可以看到具体的代码
	...
	define void @test(i32, i32) #0 {
  	%3 = alloca i32, align 4
  	%4 = alloca i32, align 4
  	%5 = alloca i32, align 4
  	store i32 %0, i32* %3, align 4
  	store i32 %1, i32* %4, align 4
  	%6 = load i32, i32* %3, align 4
  	%7 = load i32, i32* %4, align 4
  	%8 = add nsw i32 %6, %7
  	%9 = sub nsw i32 %8, 4
  	store i32 %9, i32* %5, align 4
  	ret void
	}
	//上面代码是test函数的IR Text格式的表现形式。
	/*
	语法分析：
	1、注释以分号;开头
	2、全局标识符以@开头，局部表示符以%开头，比如上面的%3说明是局部变量
	3、alloca,在当前函数栈帧中分配内存
	4、i32,32bit,4个字节的意思
	5、align 内存对齐
	6、store 写入数据
	7、load 读取数据  
	*/
  ```
    * memory：内存格式
    * bitCode：二进制格式，扩展名.bc 
    ```
    $clang -c -emit-llvm main.m
    //执行完成后可以看到生成了一个main.bc文件。
    ```

* 目标代码生成：根据IR生成依赖具体机器的汇编语言。

##### 3、**汇编**：把上面得到的.s文件里的汇编指令翻译成机器指令
```
clang -C xx.s -o xx.o
```
##### 4、**链接**：把目标文件（一个或多个）和需要的库（静态库、动态库）链接成可执行文件Mach-O
```
clang xx.o -o xx
```

[LLVM and Clang](https://www.jianshu.com/p/037fb5002b77)
#### MachO文件
MachO文件是iOS和OS X操作系统的可执行文件格式。
因为不同的CPU平台支持的指令集不一样，所以通常不同的CPU对应不同格式的MachO文件，比如arm64和x86。**通用二进制文件**则是指多种架构下的Mach-O文件"打包"在一起。
通用二进制文件常用命令：
```
//查看通用二进制文件中的MachO文件信息
$ file bq 
$ otool -f -V bq

//lipo命令增、删、提取指定的MachO文件
//提取
$ lipo bq -extract armv7 -o bq_v7
//删除
$ lipo bq -remove armv7 -o bq_V7
//瘦身
$ lipo bq -thin armv7 -o bq_V7
```
MachO文件里主要就是代码和数据（全局变量）。而代码段和数据段是存在不一样的内存地址的，所以这个就需要**链接器**将其关联起来。

#### 静态库与动态库
* 静态库：以.a和.framework为后缀；链接是会被完整复制到可执行文件中，被多次使用就有多份拷贝；
* 动态库：以.tbd和.framework为后缀；链接时不复制，而是由运行时动态加载到内存，系统只加载一次，多个程序共用，比如UIKit.framework;