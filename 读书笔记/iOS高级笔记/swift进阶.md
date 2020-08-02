---
title: swift进阶.
date: 2020-8-1 8:00:00
tags: swift
categories: swift进阶
description:  这篇文章主要是重新学习swift
---

### 基础语法

* 常量只能赋值1次，不要求在编译时期确定，使用之前必须赋值1次。

* 常见数据类型：(注意：swift就两种基本数据类型值类型和引用类型，不存在什么基本数据类型，比如Int不算是基本数据类型，Int是结构体)
  * 值类型： 枚举Enum（Optional）；结构体 ( Bool，Int，Float，Double，Character，String，Array，Dictionary，Set )
  * 引用类型：类Class

* 区间运算：
  * 闭区间运算符：a...b  ， a <= 取值 <= b ； a、b可以是常量，也可以是变量
  * 半开区间运算符：a..<b ，a <= 取值 < b ；
  * 单侧区间（主要用于数组上）：array[2...] 表示从第2个下标一直到最后；array[...2] 表示从第0个下标一直到第2个下标；array[..<2] 表示从第0个下标一直到第2个下标，但是不包含第2个下标；
  * 区间类型：
  ```
  //三种区间类型
  let range1:ClosedRange<Int> = 1...3
  let range2:Range<Int> = 1..<3
  let range3:PartialRangeThrough<Int> = ...5
  
  let stringRange = "a"..."f" //表示从字面a到字面f之间的字母。
  stringRange.contains("d") //true
  stringRange.contains("h") //false
  
  //\0到~囊括了所有可能用到的ASCII字符
  let characterRange:ClosedRange<Character> = "\0"..."~"
  //所有整数
  let numRange:ClosedRange<Character> = "0"..."9"
  //带间隔的区间值，表示从4...11，每隔两个值打印一次。
  for i in stride(from:4, through:11, by: 2) {
        print(i) //4、6、8、10
  }
  ```

* switch：不写break，不会贯穿效果，需要加贯穿效果，需要加fallthrough；case和where语句的使用。

* enum枚举：
  * 关联值：case points(Int);
  * 原始值：enum Poker : Character {},说明枚举里的case都默认使用相同类型的默认值。隐式原始值，也就是说使用了原始值是Int、String的枚举，case没有赋值的话，swift会自动分配原始值，String默认是case的名字，Int直接从0开始。
  * 递归枚举：也就是枚举里的case成员也用到了自身枚举类型。使用递归枚举需要使用**indirect**关键字
  ```
  enum AirExpr{
  	case number(Int)
  	indirect case sum(AirExpr,AirExpr)
  	indirect case difference(AirExpr,AirExpr)
  }
  let five = AirExpr.number(5)
  let four = AirExpr.number(4)
  let two = AirExpr.number(2)
  let sum = AirExpr.sum(five,four)
  let diff = AirExpr.difference(sum,two)
  ```
  * 枚举内存：使用一个字节存储成员值，N个字节存储关联值（N取占用内存最大的关联值），任何一个case的关联值都共用这N个字节。
  ```
  enum TestEnum {
      case test1,test2,teat3
  }
  enum TestEnum2 : Int {
      case test1,test2,teat3
  }
  上述两种情况都没有关联值，TestEnum只有原始值。所以只需要分配一个字节存储枚举的成员值（是哪个case）。
  enum TestEnum3 {
      case test1(Int,Int,Int)
      case test2(Int)
      case test3(Bool)
      case test4
  }
  TestEnum3含有关联值，最大的关联值有3个Int类型的，每个Int类型占用8个字节，所以需要24个字节来存储关联值，其它的关联值也共用这些存储空间。其次需要一个字节大小来存储枚举的成员值。所以实际使用25个字节，但是由于内存对齐问题，所以系统会分配32个字节给这个枚举。
  
  ```

* 函数：
  * 默认参数并不需要从右到左(c++)，因为swift含有参数标签；
  * 可变参数：一个函数最多只能有一个可变参数;紧跟在可变参数后面的参数不能省略参数标签
  ```
  func sum(_ nums:Int..., n:Int) -> Int {
  	var total = 0
  	for n in nums {
            total += n
  	}
        return total
  }
  ```
  * 输入输出参数: **inout** 在函数内部修改外部变量(当然是值类型的情况)，实际上inout的本质也就将原来值传递的过程改成了地址传递的过程。
  * 函数重载(overload)：规则就是函数名相同+（参数个数不同||参数类型不同||参数标签不同）；注意swift的函数重载跟返回值无关，其次要注意可省参数的问题。
  * 内联函数（内联是指编译器会直接将函数体复制到调用位置）：xcode在release模式下，默认开启优化，编译器会将某些函数变成内联函数。那哪些函数不会被内联优化呢？函数太长、包含递归、包含动态派发。
  * 函数类型：每一个函数类型是由形式参数类型+返回值类型组成，比如(Int,Int)->Int。所以函数就也是一种类型，那函数就可以作为参数传递，也可以作为返回值，或者属性等。返回值时函数类型的函数，叫做**高阶函数**。
  ```
  func sum(v1:Int, v2:Int) -> Int {
        v1 + v2 //只有一句代码可以省略return
  }
  func printF(_ mfun:(Int,Int)->Int, _ a:Int, _ b:Int) {
        print("\(mfun(a,b))")
  }
  printF(sum,2,3)
  ```

* typealias：用来给类型起别名。比如swift没有Long，typealias Long = Int64，比如block。

* MemoryLayout：获取某种类型的size ： MemoryLayout<Int>.size；MemoryLayout.size(ofValue: 10)

* 可选项Optional：
  * 可选类型初始值为nil。
  * 空合并运算符 ?? ， a ?? b ， a不为nil,返回a，a为nil,返回b;
  * guard 提前退出使用。
```
//遍历数组，将遇到的正数相加，遇到负数或非数字，停止遍历
var strs = ["10","20","abs","30"]
var i =0, sum = 0
while let num = Int(strs[i]), num > 0 {
    sum += num
    i += 1
}
print(sum)
```
* 结构体：在swift标准库中，绝大多数的公开类型都是结构体，枚举和类只占一小部分。比如Bool、Int、Double、String、Array、Dictionary等。
  * 所有的结构体都有一个编译器自动生成的初始化器，初始化器可以传入所有成员值，用以初始化所有存储属性。也可能会有多个初始化器，但是宗旨就是：保证所有成员都有初始值。
  * 一旦自定义了初始化器，编译器就不会再帮它自动生成初始化器。
  * 结构体
* 类：swift没有为类自动生成带参初始化器，只有一个无参的初始化器，成员的初始化值就是在这个初始化器中完成的。
* 结构体与类的本质区别：
	* 结构体是值类型（枚举也是），类是引用类型；
	* 值类型的存储位置取决于它创建的位置，如果是在栈空间中创建(比如结构体在函数内部创建)，那么它就存储在栈空间；如果是全局变量，那应该是在数据区；如果是定义在一个类内部，则是存储在堆中。引用类型无论在哪里创建都是存储在堆空间，指向引用类型的变量则也是根据这个变量的位置来确定存储位置（和值类型一样的）。
	```
	class Size{
        var w = 1
        var h = 1
        var p = Point() //在类中创建，则它跟随类存储在堆区。
	}
	struct Point {
        var x = 3
        var y = 4
	}
	
	func test() {
        var size = Size() //等号左边的是指针变量存储在栈空间，等号右侧是引用对象，存储在堆空间
        var point = Point() //结构体在当前函数栈中创建，所以它存储在栈空间中。
	}
	
	var point = Point() //在全局区创建，则是在已初始化区
	
	```
	* 值类型赋值给var 、let 或者函数参数时，是直接将所有内容拷贝一份，产生一个全新的副本，属于深拷贝；所以Array、Dictionary进行赋值其实都是深拷贝。其次swift标准库中（也就是自己定义的结构体除外），为了提升性能，String、Array、Dictionary、Set采取了Copy On Write技术。也就是说在对新赋值的变量进行修改时才会进行深拷贝，否则就是浅拷贝。
	* 引用类型赋值给var 、let 或者函数参数时，是将内存地址拷贝一份，类似浅拷贝；
