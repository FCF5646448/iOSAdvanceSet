Mach-O的生成过程：

以下C语言代码为例：

```
#include <stdio.h>
int main(int argc, char *argv[])
{
	printf("hello World!\n");
	return 0;
}
```

* 预编译：$ xcrun clang -E helloworld.c

  预编译主要包括:

  * 头文件的导入：#include<xxx.h>。这种导入是直接将xxx.h的内容插入到#include的位置。又因为xxx.h又包含其他文件，所以这又是一个递归的过程。
  * 宏的替换：#define xx
  * 预编译指令的处理：#if #else
  * 注释的处理等。

* 编译：$ xcrun clang -S helloworld.c -o helloworld.s

  生成汇编代码文件

  其实生成汇编的过程可以先细分为以下几步：

  * 词法分析：$xcrun clang -fmodules -fsyntax-only -Xclang -dump-tokens helloworld.c

  * 语法分析： $xcrun clang -fmodules -fsyntax-only -Xclang -ast-dump helloworld.c

  * 生成LLVM IR：$xcrun clang -S -emit-llvm helloworld.c -o helloworld.ll

    





#### 参考

[Mach-O可执行文件](https://objccn.io/issue-6-3/)