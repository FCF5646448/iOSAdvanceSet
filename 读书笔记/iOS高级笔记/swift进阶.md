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
* 结构体：在swift标准库中，绝大多数的公开类型都是结构体，枚举和类只占一小部分。比如Bool、Int、Double、String、Array、Dictionary等。
  * 所有的结构体都有一个编译器自动生成的初始化器，初始化器可以传入所有成员值，用以初始化所有存储属性。也可能会有多个初始化器，但是宗旨就是：保证所有成员都有初始值。
  * 一旦自定义了初始化器，编译器就不会再帮它自动生成初始化器。
  * 结构体中的属性默认的初始值实际也是在默认初始化器中进行的赋值。相当于调用了默认初始化器。

* 类：swift没有为类自动生成带参初始化器，只有一个无参的初始化器，成员的初始化值就是在这个初始化器中完成的。类对象的内存中前面默认有8个字节指向类型信息，然后有8个字节存储ARC，之后才是成员变量。也就是说没有任何成员变量的类占有16字节的内存大小。

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
  * 引用类型赋值给var 、let 或者函数参数时，是将内存地址拷贝一份，类似浅拷贝；其次值类型的let常量的成员也是不能改的，引用类型的let常量的成员则是可以改的。

* 函数：

  * 函数不占用对象的内存空间，它是存储正在代码段中。枚举、结构体、类都可以定义函数。

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
    * 如果实参有物理地址（存储属性），且没有设置属性观察器，inout的本质就是直接将实参的内存地址传入函数(实参进行引用传递)；
    * 如果实参是计算属性或者设置了属性观察器，则采取Copy In Copy Out的做法，即：调用该函数时，先复制实参的值，产生副本(get)，然后将副本的内存地址传入函数(副本进行引用传递)，在函数内部修改副本的值，函数返回后，再将修改后的副本的值覆盖实参的值(set)
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
  * 闭包：格式：{(参数列表)->返回值类型 in 函数体代码}；一个函数和它所捕获的变量或常量环境组合起来，称为闭包。
    * 如果函数的最后一个参数是一个闭包，则可以将其作为一个尾随闭包来使用，尾随闭包是一个被书写在函数调用括号外面的闭包表达式。
    * 闭包一般是指在函数内定义的函数，一般它捕获的是外层函数的局部变量和常量；
    * 可以把闭包想象成一个类的实例对象，内存在堆空间。捕获的局部变量和常量就是对象的成员(存储属性)，组成闭包的函数就是类内部定义的方法。
  ```
  typealis Fn = (Int)->Int
  func getFn() -> Fn {
      var num = 0
      func plus(_ i:Int) -> Int {
          num += i
          return num
      }
      return plus
  }
  var fn = getFn()
  print(fn(1)) //1
  print(fn(2)) //3
  print(fn(3)) //6
  print(fn(4)) //10
  //为什么num不会被释放？汇编可以看到会生成一块堆空间用于放num，所以num不会被释放。
  
  // 其实上诉闭包就类似于下面的类。
  class Closuse {
      var num = 0
      func plus(_ i:Int) -> Int {
          num += i
          return num
      }
  }
  
  //假如plus函数没有捕获变量，那么fn其实存放的就是plus的函数地址，而不会再分配堆空间地址。这其实就不是严格意义上的闭包。
  ```
    * 自动闭包：@autoClosure。只适用于 () ——> T 格式的闭包。
* 属性：swift中的属性可以分为实例属性和类型属性，实例属性又可以分为两大类：存储属性和计算属性。类型属性则是类的属性，类似于类方法。
	```
	struct Circle {
        /// 存储属性
        var radius: Double
        /// 计算属性
        var diameter: Double {
            set{
                radius = newValue / 2
            }
            get {
                radius * 2
            }
        }
	}
	```
	* 存储属性的特点：
	  *  类似于成员变量的概念
	  *  存储在实例的内存中
	  *  结构体和类可以定义存储属性
	  *  枚举**不可以**定义存储属性。因为按照枚举的内存分析，枚举中要么用一个字节只存储原始类型，要么用n个字节存储关联值。而不会开辟空间存储存储属性。
	  *  在创建类或结构体实例时，必须为所有存储属性设置一个合适的初始值。可以在默认初始化器里为存储属性设置初始值，也可以在定义的时候默认一个属性值。
	  *  延迟存储属性：lazy var car = Car()。在第一次用到属性的时候才会进行初始化。注意：**如果多个线程同时第一次访问lazy属性，那么它是无法被保证只初始化1次的。**。 其次延迟属性实际也是存储在实例变量的内存当中的，所以结构体的话，只有var修饰的实例变量才能访问延迟存储属性，因为延迟属性初始化的时候必然会修改结构体的内存
	* 计算属性：
	  * 本质就是方法(函数)
	  * 不占用实例内存
	  * 枚举、结构体、类都可以定义计算属性 
	  * 计算属性只能用var，不能用let，因为计算属性是会发生变化的。也可以设置只读属性。其次let属性被要求必须在类初始化之前必须有值。
	  * 比如枚举的rawValue是一个只读的计算属性
	* 类型属性：只能通过类型访问，类似于类方法的使用。使用static关键字。整个程序运行过程中，只存在1份，类似于全局变量；单例就是类型属性的最佳实践 
	* 属性观察器，只有非lazy的存储属性才能设置属性观察器willSet{},didSet{}。因为计算属性的观察可以直接在set和get中。其次初始化器中是不会触发属性观察器。
	* 



