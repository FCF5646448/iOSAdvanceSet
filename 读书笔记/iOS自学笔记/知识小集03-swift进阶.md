---
title: swift进阶.
date: 2020-8-1 8:00:00
tags: swift
categories: swift进阶
description:  这篇文章主要是重新学习swift
---

### 基础语法

* 常量只能赋值1次，不要求在编译时期确定，使用之前必须赋值1次。

* 常见数据类型：(注意：**swift就两种基本数据类型值类型和引用类型，不存在什么基本数据类型，比如Int不算是基本数据类型，Int是结构体**)
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
  * guard 提前退出使用；
  * 可选型的本质就是枚举；
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

  * 类有2种初始化器：指定初始化器（designed initializer）、便捷初始化器（converience initializer）。 每个类至少有一个指定初始化器，指定初始化器是类的主要初始化器，**默认初始化器总是类的指定初始化器**。这么做的目的就是安全性——保证所有的存储属性都在指定初始化器中得到初始化，那其他部分成员初始化的方法就可以作为便捷初始化器使用。
  * 初始化器的调用规则：
  	* 指定初始化器必须从它的直系父类调用指定初始化器；
  	* 子类的指定初始化器不能调用自身的指定初始化器；
  	* 便捷初始化器必须从相同的类里调用另一个初始化器；
  	* 便捷初始化器最终必须调用一个指定初始化器； 
  	* 便捷初始化器只能横向调用(调用自己的初始化器)，指定初始化器才可以纵向调用；
  * 两段式初始化：
  	* 第一阶段：初始化所有存储属性：也就是说从子类的初始化器开始一路调用父类的初始化器，最终保证整个初始化链条中的所有类的所有存储属性都得到初始化。也就是说在调用父类的初始化器（这个肯定是指定初始化器）之前，需要先对自己的存储属性进行初始化，且这个阶段不能够调用方法。
  	* 第二阶段：设置新的存储属性：也就是说在整个初始化链完成后，可以在后续代码中重新给存储属性赋值，此时也可以使用self做任何事情。
  ```
  class Person {
      var age:Int
      func init() {
          //因为Person是基类，所以在age初始之前，是不可以调用方法的
          // fuc() 这里会报错
          self.age = 1
          //在age初始化之后，就可以开始调用函数了
          fuc()
      }
      
      func fuc(){
          print("xxx")
      }
  }
  
  class Student : Person {
      var name:String
      init(age: Int, name: String) {
          //name的赋值必须放在调用父类的指定初始化器之前。
          self.name = name
          //子类指定初始化器必须调用直系父类的指定初始化器
          super.init()
          //初始化链完成之后，可以给name设置新值
          self.name = " \(name) 001"
      }
      
      converience init() {
          //最终必须调用自身类的指定初始化器
          self.init(age: 10, name: "fcf")
      }
  }
  ```
  * 重写父类初始化器：重写也就意味着函数名、参数个数、参数类型、参数标签都是一样的。重写必须要加上**override**关键字，但是有一个点要注意，因为便捷初始化器都是横向调用，所以子类是没法重新父类的便捷初始化器，或者说即使满足了重写的规则（函数名、参数个数、参数类型、参数标签都是一样），那也无需加**override**关键字。其次无论其是重写的是指定初始化器还是将指定初始化器重写为便捷初始化器，最终都必须满足上述初始化器的调用规则。

  * 如果子类没有定义任何指定初始化器，那么它会**自动继承**父类的所有指定初始化器，但是一旦有自身的指定初始化器，则不能再直接使用其父类的指定初始化器。同样的如果没有指定任何初始化器，那么它也可以继承其父类的便捷初始化器。 

  * 用**required**修饰指定初始化器（注意如果修饰的是converience初始化器，则没有实际意义），表明其所有子类都必须实现该初始化器（通过继承或者重写实现）；也就是说一个类可能存在很多指定初始化器，但是一旦有一个初始化器被required修饰了，那么子类就必须实现这个指定初始化器；也就是说如果没有自定义的指定初始化器，那么子类就自动继承了该required指定初始化器；那如果一旦子类自定义了自身的指定初始化器，那么它也得重写父类的required指定初始化器

    ```
    class Person {
        required init(){ }
        init(age: Int){ }
    }
    class Student : Person {
        //情况1、如果这个子类没有任何指定初始化器，那么就会自动继承父类的所有指定初始化器，包括required指定初始化器
        ...
        //情况2、如果子类有自己的指定初始化器
        init(no: Int) {
            //首先自身的指定初始化器，一定得调用直系父类的指定初始化器
            super.init(age: 0)
        }
        // 但是其也得实现父类的required指定初始化器,且可以不写override关键字，但是必须写required关键字
        required init() { }
    }
    ```

  * 可失败初始化器：类、结构体、枚举都可以使用**init?**定义可失败初始化器。比如如果在某种条件下，你想让初始化失败，返回nil，那么就可以使用可失败初始化器。所以这种情况下返回的也是Optional类型，那么也就意味着可以使用**init!**初始化隐私解包的初始化器。
  ```
  class Person {
      var name: String
      init?(name: String) {
          if name.isEmpty {
              return nil
          }
          self.name = name
      }
      
      converience init?() {
          //这里，可失败初始化器可以调用可失败初始化器
          self.init("") 
          //如果上一行的可失败初始化器失败了，也就是返回了nil，则它之后的代码都不会执行了，也就是这行代码不会执行。
          self.name = "fcf"
      }
  }
  ```
  * 析构：deinit

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
    * 自动闭包：@autoClosure。只适用于 () ——> T 格式的闭包；
    * mutating：值类型（结构体、枚举）在默认情况下，其值类型的属性不能被自身实例方法修改，如果要允许这种修改，则需要加上mutating关键字；
    * @discardableResult 表示可以忽略返回值；
    * 使用subscript可以给任意类型添加下标功能。实例方法和类方法都可以定义下标；
    * @escaping：逃逸闭包。
    	* 非逃逸闭包、逃逸闭包，一般都是当做参数传递给函数；
    	* 非逃逸闭包：闭包调用发生在函数结束之前，闭包调用在函数作用域内；
     * 逃逸闭包：闭包有可能在函数结束后调用，闭包调用逃离了函数作用域。
          ```
            	typealias Fn = () -> ()
            	//非逃逸
            	func test1(_ fn: Fn) {
            fn()
            	}
            	//逃逸闭包
            	var gFn: Fn?
            	func test2(_ fn: @escaping Fn) {
            gFn = fn
            	}
            	// 多线程下的逃逸闭包。因为fn()可能是在test3函数调用完成后才调用。而且async源码实际也是一个逃逸闭包。所以async闭包里使用了实例成员，编译器会强制要求明确写self。
            	func test3(_ fn: @escaping Fn) {
            DispatchQueue.global().async {
                fn()
            }
            	}
          ```

    	```

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
  * 属性观察器，只有非lazy的存储属性才能设置属性观察器willSet{},didSet{}。因为计算属性的观察可以直接在set和get中。其次初始化器中是不会触发属性观察器，注意这里的意思是在存储属性初始化时，没法触发，但是一旦初始化完成再设置新值（可以参考初始化器的两段式初始化，这里指的是第二阶段）则可以触发属性观察器。

* 继承
  * 只有类支持继承，值类型不支持继承；
  * 子类可以用override重写父类的方法、存储属性； 
  * 被class修饰的类方法，可以被子类override重写，被static修饰的类方法，不允许被override重写。
  * 可以在子类中为父类属性增加属性观察器；

* 多态：父类类型指向子类对象就是多态。在OC中使用runtime实现多态，在C++中，使用虚函数表实现多态。

  * 上面类中说到，类内存中前8个字节是用来存储类的类型信息，这8个字节实际指向另一个新的内存区域，这个内存区域的内容存储的是类的类型信息及类的方法地址。
  * 也就是说在编译完成时，每个类的类型信息就基本确定了，然后存储在全局区域。当实例化的时候，会根据类的前8个字节先取出类的类型信息及函数信息，然后调用函数的时候就会调用真正类型的函数。也就是使用的是类似C++的虚函数表的方式实现的多态。

* 协议
  * 协议中属性，需要标识读写属性。协议可以作为传参使用；
  * CaseIterable 枚举遵循这个协议，可以实现遍历枚举；
* Any、AnyObject: Any表示任意类型，AnyObject表示任意类类型；
* X.self、X.type:  
  * X.self : 是表示原类型的数据。也就是上述说到的堆内存中首8个字节所指向的空间地址，表示当前对象的真实类型；
  * X.Type表示当前类型，X.self属于X.Type
  ```
  protocol  Runnable {
        func test() -> Self //返回当前类
  }
  class Person : Runnable {
        required init() { }
        func test() -> Self {
            type(of: self).init() //这样才能返回最终的类型,Self返回值必须调用required初始化器。
        }
  }
  class Student : Person {}
  var stu = Student()
  stu.test()
  
  //注意：以下4张方法最终都是调用init()方法初始化，底层其实都没什么区别。
  var p0 = Person()	
  var p1 = Person.self() 
  var p2 = Person.init()
  var p3 = Person.self.init()
  var p4 = type(of: p0).init()
  
  //获取类型
  var pType:Person.Type = Person.self
  
  ```

* 错误。

  * 如果函数有可能要抛出错误，则在函数上用**throws**关键字声明。然后使用**try**关键字调用可能会抛出异常的函数。使用do{}catch处理最终抛出的错误。
  ```
  enum MyError : Error {
    	case illegalArg(String)
    	case outOfBounds(Int, Int)
    	case outOfMemory
  } 
  
  func divide( _ num1: Int, _ num2: Int) throws -> Int {
    	if num2 == 0 {
        	throw MyError(msg: "0不能作为除数")
    	}
    	return num1 / num2
  }
  
  do {
     	let result = try  divide(1,0)
     	print(result)
  }catch let MyError.illegalArg(msg){
    	print("参数错误:", msg)
  }catch let MyError.outOfBounds(size, index){
    	print("下标越界:", "size=\(size)", "index=\(index)")
  }catch let MyError.outOfMemory{
  		print("内存溢出")
  }catch {
   		print("其他错误")
  }
  ```
  * rethrows：表明函数本身不会抛出错误，但是调用闭包参数抛出错误，那么它会将错误向上抛。
  ```
  func exec(_ fnc: (Int, Int) throws -> Int, _ num1: Int, _ num2: Int) rethrows {
        print(try fnc(num1, num2))
  }
  
  try exec(divece,20,20)
  ```
* defer: 定义以任何方式在离开代码块之前定义必须要执行的代码。 
* 泛型：将类型参数化，提高代码复用率，减少代码量；
  ```
  func swapValue<T>(_ a: inout T, _ b: inout T) {
    	(a, b) = (b, a)
  }
  
  //假设要将泛型函数传递给某个变量
  var fn: (inout Int, inout Int) -> ()  = swapValue
  var n1 = 10
  var n2 = 20
  fn(&n1, &n2)
  
  //定义一个泛型类型
  class Stack<T> {
    	var elements = [T]()
    
    	init(first: T) {
        	element.append(first)
    	}
    	func push(_ element: T) {
        	elements.append(element)
    	}
    	func pop() -> T {
        	element.reloveLast()
    	}
  }
  
  //如果初始化函数里声明了类型，那么就不要使用<T>标识具体类型。
  let stack = Stack(first: 10)
  ```

  * 关联类型 associatedtype , 给协议中用到的类型定义一个占位名称。遵守协议的时候，可以使用typelias 先设定真实类型，不过其实也可以省略，直接设置具体类型。   
  * 使用some关键字声明不透明类型, some限制只能返回一种类型
  ```
  protocol Runnable {
        associateType Speed
        var speed: Speed {get}
  }
  class Person : Runnable {
        var speed: Double {0.0}
  }
  class Car : Runnable {
        var speed: Int {0}
  }
  
  // 如果这里只返回1种类型，可以加上some限制
  func get1(_ type: Int) -> some Runnable {
        return Car()
  }
  
  func get(_ type: Int) -> Runnable {
        if type == 0 {
            return Person()
        }
        return Car()
  }
  
  var r1 = get(0)
  var r2 = get(1)
  
  // 使用some解包可选类型
  var age: Int? = 10
  age = 20
  age = nil
  
  switch age{
  case let .some(v):
      print("1",v)
  case .none:
  	print("2")
  }
  
  ```
* 汇编学习String
  * String： 字面量一旦字符串的长度小于等于15，那么字符串直接存储在16个字节的变量内存里面，类似OC的tag pointer。如果长度超过了15，则存储在常量区；在使用append函数时，如果append之后字符串长度超过了15个字符，则会调用malloc函数开辟堆空间，如果长度依旧小于15，则还是直接存放在变量内存里面。
  ```
  let str = "0123456789ABCDE" //存储在str的地址里面
  let str1 = "0123456789ABCDEF" //存储在常量区
  str1.append("G")			// 存储在堆空间
  ```

* 运算符
  * 溢出运算符：&+、&-、&*。溢出的话，会重新循环进这个范围。
  ```
  // UInt8 取值范围在0~255
  var v: UInt8 = UInt8.max
  v += 1 //这里就会产生溢出
  v = v &+ 1 //溢出运算符，溢出的话，会重新回到0，
  ```
  * 运算符重载：类、结构体、枚举都可以实现运算符重载. （重载 意味着函数名相同，但是功能不一样）
  ```
  struct Point {
        var x = 0, y = 0
        static func +(p1: Point, p2: Point) -> Point {
    		Point(x: p1.x + p2.x, y: p1.y + p2.y)
    	}
  }
  
  	
  
  var p1 = Point(x: 10, y: 20)
  var p2 = Point(x: 11, y: 22)
  
  
  ```
### 项目开发
* 访问权限控制：swift一共提供了5种访问权限控制。下面由高到低
  * open：允许在定义实体的模块(模块就指一个target)、其他模块中访问，允许其他模块进行继承、重写。但是**open只能用在类、类成员上，不能用在实例成员、结构体、枚举上**；

  * public：允许在定义实体的模块(也就是项目所有文件)、其他模块(包括其他target)中访问，但是不允许其他模块进行继承、重写；比如，我们自己的pod库，如果想要其他pod库访问，则必须显示写清楚public。

  * internal：只允许在定义实体的模块中访问，不允许在其他模块中访问；**系统默认权限**

  * fileprivate：只允许在定义实体的源文件中访问，也就是说只允许在当前文件中访问；

  * private：只允许在定义实体的封闭声明中访问，也就是在{}内允许访问；比如private定义的类在全局作用域里，则表明在当前文件内都可以访问。扩展如果没有另外设置权限，则整个扩展则就默认是原类的访问权限。

    ```
    //这里private定义在全局作用域里，所以表明它在当前文件实体内都可以访问。所以这里即使person的作用域级别小于Student，也仍然不会报错，因为此时private和fileprivate的作用域是一样的。
  private class Person{}
    fileprivate class Student : Person {}
    
    // 这里将上面函数放到class内部，那么private的作用域就是在Test{}内部，fileprivate则是当前文件，相当于子类作用域大于父类作用域，所以这样是会报错的。
    class Test {
        private class Person{}
    	fileprivate class Student : Person {}
    }
    
    //这里private(set)表明age的set权限是private，所以外面只能get到age的值，不能对age进行set操作。
    class Person {
        private(set) var age = 10
    }
    
    ```

* 内存管理
  swift 也采用基于引用计数的ARC内存管理方案(针对堆空间)。swift的ARC有3种
  * 强引用：默认情况下，都是强引用，strong；
  * 弱引用：通过weak定义弱引用；但是swift中，
    * 弱引用必须是可选类型；
    * 使用var修饰；
    * 实例销毁后，ARC会自动将弱引用设置为nil；
    * 另外ARC自动给弱引用设置nil时，是不会触发属性观察器的；
  * 无主引用：通过unowned修饰。
    * 不会产生强引用，非可选类型，
    * 实例销毁后仍然存储着实例的内存地址。类似于OC的unsafe_unretained。所以在实例销毁后访问无主引用，会产生野指针错误；
  * 循环引用：weak、unowned都能解决循环引用的问题，unowned要比weak少一些性能消耗。
    * 在生命周期中可能会变为nil，使用weak；

    * 初始化赋值后再也不会变为nil，使用unowned； 

* 模式匹配
  * 枚举case模式：if case 语句等价于只有一个case的switch语句。
  ```
  let age = 2
  // 老式写法
  if age >= 0 && age <= 9 {
        print("匹配成功")
  }
  //if case 匹配。注意这里的=不是赋值的意思，而是匹配的意思
  if case 0...9 = age {
        print("匹配成功")
  }
  // guard 样式
  guard case 0...9 = age else {return}
  print("匹配成功")
  
  // for 循环里使用case
  let ages: [Int?] = [2,3,nil,5]
  for case nil in ages {
        print("有nil值")
        break
  }
  let points = [(1,0),(2,1),(3,0)]
  for case let (x, 0) in points { //匹配y为0的point 
        print(x)
  }
  
  ```
  * 自定义表达式模式。可以通过重载运算符~=，自定义表达式模式的匹配规则。
  ```
  struct Student {
        var score =0, name = ""
        static func ~= (pattern: Int, value: Studnt) -> Bool { value.score >= pattern }
        static func ~= (pattern: CloseRange<Int>, value: Student) -> Bool { pattern.contains(value.score) }
        static func ~= (pattern: Range<Int>, value: Student) -> Bool { pattern.contains(value.score) }
  }
  
  var stu = Student(score: 75, name: "jack")
  switch stu {
    case 100: print(">= 100")
    case 90: print(">= 90")
    case 80..<90: print("[80, 90]")
    case 60...79: print("[60, 79]")
    case 0: print(">= 0")
    default: break
  }
  
  // 字符串前后缀匹配
  func hasPrefix(_ prefix: String) -> ((Strign) -> Bool) { { $0.hasPrefix(prefix) } }
  func hasSuffix(_ prefix: String) -> ((Strign) -> Bool) { { $0.hasSuffix(prefix) } }
  extension String {
        static func ~=(pattern: ((String) -> Bool, value: String) -> Bool {
            pattern(value)
        }
  }
  
  var str = "123456"
  switch str {
    case hasPrefix("123"), hasSuffix("456"):
        print("以123开头")
        pritn("以456结尾")
    default: break
  }
  
  //eg: 奇偶数匹配
  func isEvent(_ i: Int) -> Bool { i % 2 == 0 }
  func isOdd(_ i: Int) -> Bool { i % 2 != 0 }
  extension Int {
        static func ~=(pattern: (Int) -> Bool, value: Int) -> Bool {
            pattern(value)
        }
  }
  
  var age = 9
  switch age {
    case isEvent:
        print(age, "是个偶数")
    case isOdd:
    	print(age, "是个奇数")
    default: break
  }
  ```
  * where 可以使用where为模式匹配增加匹配条件。

* 字面量
  * Swift自带类型之所以可以通过修改字面量初始化，是因为它们遵守了对应的协议
  ```
  Bool: ExpressibleByBooleanLiteral
  Int: ExpressibleByIntegerLiteral
  Float、Double: ExpressibleByInterLiteral、ExpressibleByFloatLiteral //所以Float和Double可以使用整型和浮点型进行字面量初始化
  Dictionary: ExpressibleByDictionaryLiteral
  String: ExpressibleByStringLiteral
  Array、Set: ExpressibleByArrayLiteral
  Optional: ExpressibleByNilLiteral
  ```
  eg1: 使Int遵守Bool类型协议，使Int可以使用Bool进行字面量初始化
  ```
  extension Int: ExpressibleByBooleanLiteral {
        public init(booleanLiteral value: Bool) {
            self = value ? 1 : 0
        }
  }
  var num: Int = false
  print(num) //这个时候num是bool类型
  ```
  eg2: 使用字面量初始化自定义的类型
  ```
  class Student : ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral, CustomStringConvertible {
        var name: String = ""
        var score: Int = 0
        required init(floatLiteral value: Double) { self.score = value }
        required init(integerLiteral value: Int) { self.score = value }
        required init(stringLiteral value: String) { self.name = value }
        required init(unicodeScalarLiteral value: String) { self.name = value }
        required init(extendedGraphemeClusterLiteral value: String) { self.name = value }
        var description: Sting { "name=\(name), score=\(score)"}
  }
  var stu: Student = 90
  print(stu)
  stu = 98.5
  pritn(stu)
  stu = "Jack"
  print(stu)
  ```
  eg3: 字面量初始化结构体
  ```
  stuct Point {
        var x = 0.0, y = 0.0
  }
  extension Point : ExpressibleByArrayLiteral、ExpressibleByDictionaryLiteral {
        init(arrayLiteral elements: Double...) {
            guard elements.count > 0 else { return }
            self.x = elements[0]
            guard elements.count > 1 else { return }
            self.y = elements[1]
        }
        init(dictionaryLiteral elements: (String, Double)...) {
            for (k, v) in elements {
                if k == "x" { self.x = v }
                else if k == "y" { self.y = v }
            }
        }
  }
  var p: Point = [10.5, 20.5]
  pritn(p)
  p = ["x" : 11, "y" : 22]
  pritn(p)
  ```
  * 可以通过typealias修改字面量的默认类型
  ```
  typealias FloatLiteralType = Float
  typealias IntegerLiteralType = UInt8
  var age = 10 //UInt8
  var height = 1.68 //Float
  ```

* 代码风格与习惯
  * 注释： // MARK: 、// MARK: -、// TODO:、// FIXME:
  * warning //如果要更加明显地注释，可以使用#warning, eg: #warning("undo")
  * fetalError() //如果不想写注释，或者遇到暂时不想实现的方法，则可以使用fetalError()先让程序崩溃

* 程序入口
  程序入口其实就是在Appdelegate的默认的@UIApplicationMain标记里。
  * 自定义main程序入口
  如果要自定义main程序入口，第一步需要把@UIApplicationMain标记注释的，然后重新创建一个main.swift文件。然后重写以下代码：
  ```
  import UIKit
  //自定义UIApplication 这一步是可选的。
  class MyApplication: UIApplication {}
  UIApplicationMain(CommandLine.argc,
  					CommandLine.unsafeArgv,
  					NSStringFromClass(MyApplication.self),
  					NSStringFromClass(AppDelegate.self))
  ```

* OC 到 swift：
  * 条件编译：
    * 在xcode debug编译标记设置custom DEBUG标记。是的代码可以直接使用#if DEBUG ，但是得放在函数里调用。
    * log 条件打印
    ```
    func log<T>(_ msg: T, 
    file: NSStrign = #file, 
    line: Int = #line, 
    fn: String = #function) {
            #if DEBUG
            let prefix = "\(file.lastPathComponent)_\(line)_\(fn):"
            print(prefix, msg)
            #endif
    }
    ```

  * 如果要将类中的某个成员变量暴露给OC，则在成员变量前面加上@objc，如果要将Swift的所有成员都暴露给OC，则给类加上 @objcMembers, 这样就不需要每个成员变量前面都加上@objc；

  * 可以通过@objc重命名swift暴露给OC的符号名（类名，属性名，函数名等）
  ```
  @objc(FCFCar) //重命名类
  @objcMembers class Car: NSObject {
  	@objc(name) //重命名属性
  	var band: String
  	@objc(drive) //重命名方法
  	func run() {
            print(band, "run")
  	}
  }
  ```

  * selector选择器必须是被@objc或@objcMembers修饰。因为选择器都是在runtime中使用，而swift的runtime还是使用OC的runtime，所以必须加上@objc暴露成OC的方法；

* 代码细节
  * swift类无论是否继承NSObject或是否被@objc修饰，如果在swift类中调用，那么就是走swift 虚表调用机制，如果在OC中调用，那么就是走OC的objc_messageSend机制。swift要实现KVO和KVC，则必须是@objc dynamic修饰的。
  ```
  class Person: NSObject {
  		@objc dynamic var age: Int = 0
  		var observation: NSKeyValueObservation?
  		funt test() {
      		observation = observe(\Person.age, options: .new) {
                (person, change) in
                print(change.newValue as Any)
      		}
  		}
  }
  
  ```

  * Substring：Substring不是一个String类型，**Substring是一个单独的类型**，String的子串可以通过小标、prefix、suffix截取。Substring可以通过String强转为String类型，substring可以调用.base方法获取其对应的原始String。注意：**实际上Substring与原理String共用一块内存区域，所以可以调用base获取原来的string。如果对substring进行修改，那么此时才会拷贝一份新的内存，然后将substring放进去**。
  ```
  var str = "123456"
  var subStr1 = str.prefix(2)
  var subStr2 = str.suffix(3)
  var range = str.startIndex..<str.index(str.startIndex, offsetBy: 3)
  var subStr3 = str[range]
  //送substring中获取原理的string
  var originStr = subStr3.base
  //转成String
  var str1 = String(subStr3)
  ```
  * 多行String使用三引号："""xxx""" 包裹。

* 多线程
	* 使用DispatchWokItem包装任务。DispatchWorkItem可以使用cancel取消。
	```
	public typealias Task = ()->Void
	public struct Async {
        public static func async(_ task: @escaping Task) {
        	_async(task)
		}
		public static func async(_ task: @escaping Task, 
		_ mainTask: @escaping Task) {
        	_async(task, mainTask)
		}
		private static func _async(_ task: @escaping Task, 
		_ mainTask: Task? = nil) {
        	let item = DispatchWorkItem(block: task)
        	DispatchQueue.global().async(execute: item)
        	if let main = mainTask {
            	item.notify(queue: DispatchQueue.main, execute: main)
        	}
		}
		
		@discardableResult
		private static func _aysncDelay(_ seconds: Double, 
		_ task: @secaping Task, 
		_ mainTask: @secaping Task? = nil) -> DispatchWorkItem {
            let item = DispatchWorkItem(block: task)
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
            if let main = mainTask {
                item.notify(queue: DispatchQueue.main, execute: main)
            }
		}
		
		@discardableResult
		public static func asyncDelay(_ seconds: Double, 
		_ task: @escaping Task) -> DispatchWorkItem {
            return _aysncDelay(seconds, task)
		}
		
		@discardableResult 
		public static func asyncDelay(_ seconds: Double,
        _ task: @escaping Task, 
		_ mainTask: @escaping Task)
		return _aysncDelay(seconds, task, mainTask)
	}
	```
	* Dispatch_once：swift代码里已经废弃了Dispatch_once. 而是直接用static。static是全局变量，只会初始化一次，且默认就是lazy。其内部其实使用了Dispatch_once，所以**它也是线程安全的**。 所以**static可以保证线程安全和懒加载**
	```
	//单例
	struct Single {
		static let share = Single()
        private init() {
        }
	}
	```
	* 加锁：线程安全
	```
	public struct Cache {
		//分析：data是一个全局变量，永远只有一份内存，如果有多个线程同时调用set方法，那么就会产生数据安全问题。
        private static var data = [String: Any]()
        
        //01信号量, value 其实可以认为表示允许多少条线程同时访问
        private static var lock = DispatchSamephone(value: 1)
        //02 Lock, 递归调用会产生死锁
        private static var lock = NSLock()
        //03 递归锁
        private static var lock = NSRecursiveLock()
        
        public static func get(_ key: String) -> Any? {
            data[key]
        }
        public static func set(_ key: String, _ value: Any) {
        	//01信号量
        	lock.wait()
        	defer { lock.signal() }
        	//02 Lock
        	lock.lock()
        	defer { lock.unlock() }
        	//03 递归锁
        	lock.lock()
        	defer { lock.unlock() }
        	
            data[key] = value
        }
	}
	
	```

### 高阶

* 函数式编程
  * Array的常见操作
  	* map: 遍历Array每个元素，block里可以对元素单独处理，最终返回新的Array。返回结果的元素类型就是block里新创建的类型；
  	* filter: 遍历Array每个元素，block里添加条件语句，最终返回符合条件的新Array；
  	* reduce: 遍历Array每一个元素，block里会有两个参数，第一个参数是上一次遍历的结果，第二个参数是当前遍历元素。最后返回一个最终结果值；
  	* flatMap: 和map功能一样，只是会把二维数组压成一维数组；
  	* first: 查找第一个满足条件的元素，block是一个条件语句；
  	* firstIndex: 查找第一个满足条件的元素的索引，block是一个条件语句；
  ```
  var arr = [1,2,3]
  _ = arr.map{ $0 * 2 }
  _ = arr.map{ "abc_\($0)"}
  //传入函数
  func blockf = (_ element: Int)->String { "abc_\(element)" }
  _ = arr.map(blockf)
  // 处理可选型
  var score: Int? = 98
  //老方法
  var str1 = score != nil ? "score is \(score!)" : "no_score"
  //新方法
  var str2 = score.map{ "score is \($0)" } ?? "no_score"
  
  /*******************************************************/
  _ = arr.filter{ $0 % 2 == 0 }
  /*******************************************************/
  // $0 是上一次遍历返回的结果，初始值是传进来的那个0.$1是每次遍历的元素
  _ = arr.resuce(0){ $0 + $1 } // _ = arr.reduce(0,+)
  /*******************************************************/
  // flatMap 可选项处理
  var fmt = DateFormatter()
  fmt.dateFormat = "yyyy-MM-dd"
  var str: String? = "2011-11-11" //可能字符串为nil
  //老方法
  var date1 = str != nil ? fmt.date(from: str!) : nil
  // 新方法
  var date2 = str.flatMap(fmt.date)
  /*******************************************************/
  // 重要 —— lazy 优化
  let arr = [1,2,3]
  let result = arr.map{
        (i: Int) -> Int in
        print("mapping \(i)")
        return i * 2
  }
  print("begin---------")
  pirnt("mapped", result[0])
  pirnt("mapped", result[1])
  pirnt("mapped", result[3])
  print("end-----------")
  
  /*
  得到的结果：
  mapping 1
  mapping 2
  mapping 3
  begin---------
  mapped 2
  mapped 4
  mapped 6
  end-----------
  解析：也就是说，这里begin之前就会执行一次，然后后续使用的时候，会再调用一次。假设有1000个元素，那么就会非常耗时。
  */
  let result = arr.lazy.map{
        (i: Int) -> Int in
        print("mapping \(i)")
        return i * 2
  }
  print("begin---------")
  pirnt("mapped", result[1])
  print("end-----------")
  /*
  得到的结果：
  
  begin---------
  mapping 2
  mapped 4
  end-----------
  解析：也就是说，这里begin之前就不会执行，然后后续使用的时候，使用到哪个函数，那个函数才会具体执行。
  */
  ```

  * 函数式编程：函数式编程是一种编程范式(也就是如何编程的一种方法论)。主要思想就是把计算过程尽可能分解成一系列可复用函数的调用。函数式编程里，函数是“第一等公民”；
  	* 接收一个或多个函数作为输入或者返回一个函数的函数是高阶函数；
  	* 柯里化：将接收多个参数的函数变成一系列接收单个参数的函数； 
  	```
  	//柯里化实际的编写过程中，参数的传递顺序正好和传统方式是相反的。
  	func add1(_ v1: Int, _ v2: Int) -> Int {v1 + v2}
  	func add10(_ v1: Int) -> (Int) -> Int { { $0 + V1 } }
  	
  	func reduce1(_ v1: Int, _ v2: Int, _ v3: Int) -> {
        return v1 - v2 - v3
  	}
  	func reduce10(_ v3: Int) -> (Int) -> (Int) -> Int {
        return {v2 in
        	return {v1 in
        		v1 - v2 - v3
        	}
        }
  	}
  	reduce1(10)(20)(30)
  	/***************************************************/
  	//给定任何一个格式为 (Int, Int) -> Int 的函数，实现柯里化 (prefix表示给任意函数前加上~)
  	prefix ~<A,B,C>(_ fn: @escaping (A, B) -> C) -> (B) -> (A) -> C { {b in { a in fn(a,b) } } }
  	//调用
  	(~add1)(10)(20)
  	
  	```
  	* 函子：像Array、Optional这样支持map运算的类型，成为函子。
  	```
  	public func map<T>(_ transform: (Element) -> T) -> Array<T>
  	public func map<T>(_ transform: (Wrapped) -> U) -> Optional<U>
  	//对于任意一个函子，如果能支持以下运算，该函子就是一个适用函子
  	func pure<A>(_ value: A) -> F<A>
  	func <*><A, B>(fn: F<(A) -> B>, value: F<A>) -> F<B>
  	infix operator <*>: AdditionPrecedence
  	func <*><A, B>(fn: ((A) -> B)?, value: A?) -> B? {
        guard let f = fn , let v = value else {return nil}
        return f(v)
  	}
  	```
* 面向协议编程
  * 面向对象就是将事务抽象成对象的概念，然后给对象赋予属性和方法，让对象去执行自己的方法。它的核心思想就是使用封装、继承将一系列的相关内容放到一起。但是由于事务往往不是一脉相承的，而是由多种特质的组合，所以导致面向对象很多时候没法很好地对事务进行抽象。面向对象存在一定的问题
    * 横切关注点：也就是说如果两个在不同继承关系中的类（没有继承关系）使用了同样的代码（比如都实现了一个method()函数），那么这个代码没法共用。（解决方案可以给它们搞个父类，或者实现多继承等）。
        ```
        @interface c1: NSObject
            func method() {}
        @end
        @interface c2 : NSObject
            func method() {}
        @end
        ```

      * 菱形缺陷：比如上述问题，我们给两个类施加一个共同的父类（比如c0）,此时又有一个类c3同时继承于c1和c2。那么c3在使用的时候对于使用哪个父类的method方法就会很难确定，导致不安全。这就是菱形缺陷；

      * 动态派发安全性：比如动态类型，动态调用方法，该方法没有实现，就会导致崩溃。比如：

        ```
        C1 *c1 = ...
        C2 *c2 = ...
        NSObject *c3 = ...
        NSArray * arr = @[c1, c2, c3]
        for (id obj) in arr {
            [obj method];
        }
        ```

  * 面向协议就是通过协议来定义事务的实现。通过遵守不同的协议，来对类或结构体进行定制。它只需要实现协议里规定的属性和方法就可以。相对于面向对象，其耦合性更低，维护和扩展更灵活。其次其正好可以解决面向对象的三大缺陷问题。

    ```
    /// 定义前缀类型
    struct FCF<Base> {
        var base: Base
        init(_ base: Base) {
            self.base = base
        }
    }
    /// 利用前缀扩展前缀属性
    protocol FCFCompatible {
        var fcf: FCF<Self> {
            set{}
            get{ FCF<self> }
        }
        static var fcf: FCF<Self>.Type {
            set{}
            get{ FCF<Self>.self }
        }
    }
    
    // 给String.fcf、String().fcf 前缀扩展功能
    extension FCF where Base: ExpressibleByStringLiteral {
    	// 扩展一个字符串数字个数的实例方法
    	var numCount: Int {
            var count = 0
            for c in (base as String) where ("0"..."9").contains(c) {
                count += 1
            }
            return count
        }
        
        // 扩展一个类方法
        static func test() { }
        
        // 扩展一个mutating方法
        mutating func test1() { }
    }
    
    
    // 让String、NSString拥有前缀属性
    extension String: FCFCompatible {}
    extension NSString: FCFCompatible {}
    
    // 使用
    var str1 = "123"
    var str2: NSString = "123"
    var str3: NSMutableString = "123"
    print(str1.fcf.numCount)
    print(str2.fcf.numCount)
    print(str3.fcf.numCount)
    ```

* 响应式编程
响应式编程(Reactive Programming， RP)， 也是一种编程范式，可以简化异步编程，提供更优雅的数据绑定。比较成熟的响应式框架：ReactiveCocoa（简称RAC，有OC和Swift版本）、ReactiveX（简称Rx, 很多语言都有Rx版本，比如RxJave、RxKotlin、RxGo、RxSwift等）。
	* RxSwift 包含两部分RxSwift和RxCocoa。RxSwift是Rx标准API的Swift实现，不包括任何iOS相关内容；RxCocoa是基于RxSwift给iOS UI控件扩展了很多Rx特性。
		* Observable: 负责发送事件(Event)
		* Observer: 负责订阅（subscribe）Observable，监听Observable发送的事件（3种Event: next(携带具体数据)\error(携带错误信息，表明Observable终止，不会再发出事件)\completed(表明Observable终止，不会再发出事件)）；

