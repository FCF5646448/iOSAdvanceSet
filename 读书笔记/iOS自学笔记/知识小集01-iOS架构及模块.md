---
title: iOS-项目知识小集
date: 2020-5-9 17:36:48
tags: knoeledgePoints
categories: iOS进阶
description: 总结项目开发中的常用的进阶知识点
---


### 设计模式
设计模式简单地说就是程序开发的套路和模板。主要是 为了代码的可重用性，将某些功能的模块代码规范化，然后尽可能让他人容易理解。

任何一种设计模式都是一种设计原则。设计模式就是实现了设计原则，达到了代码复用和可维护性。设计模式又包含创建型模式、结构型模式、行为型模式。
#### 设计原则
* **单一职责原则**：一个类只承担一个职责。比如UIView和CALayer的职责分离；
* **开闭原则**：对修改关闭、对扩展开发，如果要修改也尽量用继承或组合的方式来修改。比如category给元类添加方法；
* **里氏替换原则**：是指父类可以被子类无缝替换，且原有功能不受影响； 比如说KVO原理，动态实现了一个NSNotifing的子类，而我们感受不到任何变化；
* **接口隔离原则**：使用多个专门的协议而不是一个庞大臃肿的协议，协议中方法也应该尽量少。 比如UITableView将代理分成了delegate和datasource；
* **依赖倒置原则**：抽象不应该依赖于具体实现，具体实现可以依赖于抽象。比如我们写数据库操作的时候，先用协议实现增删改查的接口，至于具体的实现：使用什么数据库、存储在什么位置等细节，上层业务则无需感知了；
* **迪米特法则**：一个对象应当对其他对象尽可能少的了解，尽可能实现高内聚、低耦合；比如项目中路由的使用，MVVM中viewmodel的使用；
#### 常用设计模式
##### 创建型模式
* 工厂方法模式：工厂模式就是给定一个工厂方法，然后通过传入的参数来确定生成具体的哪个实例。代码：
```
//一个抽象产品类：Phone,声明了一个call方法
protocol Phone {
    func call;
}
//两个具体的产品类：iPhone和HUAWEI
class IPhone : Phone {
    func call() {print("iphone call")}
}
class HUAWEI : Phone {
    func call() {print("huawei call")}
}

//工厂方法
class PhoneFactory {
    func createPhonre(_ name:String)-> Phone? {
        if name.contains("iPhonre") {
            return IPhone()
        }else if name.contains("HUAWEI") {
            return HUWEI()
        }
        return nil
    }
}

//使用
let p = PhoneFactory.createPhonre("iPhonre")
p.call()

```
优点：工厂类方法更好区分一个类簇的各色特点；缺点是一旦有新的产品添加的话，就得修改工厂方法，违反了开闭原则。
* 单例模式：保证当前类全局只有一个公共的实例；一般与懒加载一起出现，只有被需要时才会被创建
```
class Manager {
    static let share = Manager() //static 底层实现了dispatch_once和懒加载功能
    private init(){}
}
```
* 创建者模式：将复杂对象的构建与它的表示(属性、方法)分离；略
* 原型模式：简单来说就是通过深拷贝的方式创建对象；比如说A创建了一份简历，B则把A的简历拷贝了一份，然后修改了对应的姓名等部分信息。这就是原型模式的实现。
优点：对一些创建过程繁琐的对象来说，原型模式可以提高生成效率；
缺点：如果对象层级太多的话，手写clone方法也会比较复杂。
iOS 应用：OC中使用NSCopying协议，配合 (id)copyWithZone:(NSZone * )zone方法；或者使用NSMutableCopying协议配合mutableCopyWithZone方法实现。

##### 结构型模式
(这里只讲几种自己熟悉的模式)
* 适配器模式：如果无法修改一个类已有的实现，则可以生成一个新类，持有该类主要是对于一些接口，如果当前类用不上，则可以通过二次封装，让其只包含当前类可用的接口，这就是适配器模式。主要做法就是将一个类的接口转换为另一个类的接口；
* 组合模式：又叫部分整体模式，用于把一组相似的对象当作一个单一的对象。组合模式依据树形结构来组合对象，用来表示部分及整体层次。使得使用的时候，模糊了简单元素与复杂元素的概念。外界只对整体模块进行使用，而不需要了解组合里面的小模块的具体细节。
* 装饰模式：指在不修改原封装的基础上的前提下，为对象动态添加新功能的模式。在OC中，它的表现形式就是Category和Delegation，在Swift中，它的表现形式就是Extension和Delegation。(swift中的Extension与OC的Category的区别就是Extension更强大，它可以为Protocol扩展完成默认实现)；
* 外观模式：外观模式就是定义一个高层接口，为子系统中的一组接口提供一个统一的接口。也就是说，使用时直接访问高层接口，而无需访问子模块中的接口。比如**SDWebImage**，它定义了下载和缓存两个独立的子模块。但是外界调用只需要调用最上层的sd_setimageWithUrl，而无需一步步调用下载和缓存的子接口。这就是外观模式，正常来说，我们封装的大多数类，都应该尽可能设计成外观模式的设计模式。
* 桥接模式：
* 享元模式：
* 代理模式：
##### 行为型模式
(这里只讲几种自己熟悉的模式)
* **责任链模式**：责任链模式就是由一堆类似功能的类组成的一条链，如果当前类无法处理该事件，就传给下一个响应者。**最经典的就是iOS的响应链模式，就是使用了责任链模式**。另外举一个例子：银行ATM取钱，如果存在100、50、20三种币值，那么ATM的最基本的特性就是尽可能出尽量少的张数，也就是说大的币值尽可能出最多，所以可以给每种币值作为一个类，然后从大往小链接起来。每次将自身无法处理的币值传给后者。比如要取290元，取了2张100的之后，就将90传递给50的币种，去除一张50的之后，就将剩余的40传递给20的币值... 这样单独处理而不是全部放一起去处理的好处就是，如果有一种新的币值，那么可随时插入进责任链中，其次也可以根据需求来修改链中的顺序，比如尽可能出最小币值。缺点就是可能会导致处理被延时；
* 中介者模式：使用一个中介者对象来封装一系列交互，使得相互通信的两个类无需相互引用，尽可能不偶合在一起。中介者模式的应用，就是**组件化的CTMediator**；
* 备忘录模式：在不破坏封装性的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态。这样以后就可以对该对象恢复到保存之前的状态；最经典的使用例子就是UserDefault；
* 观察者模式：观察者模式定义对象直接的一种一对多依赖关系，每当一个对象状态发生改变时，其相关依赖对象皆得到通知并被自动更新。典型的例子：KVO、通知。
* 命令模式：
* 解析器模式：
* 迭代器模式：
* 状态模式：
* 策略模式：
* 模板方法模式：
* 访问者模式：

https://www.jianshu.com/p/e5c69c7b8c00


### APP常用架构
#### 架构的选择
好的架构需要关注3点需求：
* 代码均摊：合理的APP架构应该合理分配代码，每个类、结构体、方法、变量的存在都应该遵循单一职责的原则；
* 便于测试：测试确保了代码质量，我们熟知的单元测试、性能测试、UI测试都是针对单个方法或界面的。APP架构的合理分配决定了各个测试能够各司其职，不重复、不遗漏，让测试效率和覆盖率达到最大；
* 易用性：好的APP架构确保了日后开发中可以应对各种需求，易扩展、易重用；
#### MVC
Model —— View —— Controller。Model负责处理数据；view负责处理UI；Controller负责协调model和View，是它们之间的桥梁，它将数据从Model层传送到View层，并展示出来，同时将View层的交互传到Model层以改变数据；
* 优点：
	* 代码总量少、简单易懂；
* 缺点：
	* 代码过于集中，View和Model高度耦合；
	* 难以测试：太耦合，单元测试没法配合特定视图进行；
	* 难于扩展：太耦合，使得增加新功能不仅可能需要修改大量原有代码，也是的Controller愈发笨重；
	* model层过于简单；
	* 网络请求逻辑无从安放；
#### MVVM
MVVM也是在MVC的基础上添加了ViewModel层级，MVVM框架则表示Model--ViewModel--（View Controller）。它将业务逻辑、网络请求和数据解析放在了ViewModel层，大大简化了Controller层的逻辑代码，也让model 、view的功能更加独立单一。
ViewModel主要作用：

* 视图层的真正数据提供者：一般视图层展示的数据经常是一个或多个model的属性组合。ViewModel就可以将这些数据整合，使得视图直接调用单个数据就能展示所要的效果。简单来说，就是可以对模型层的数据进行包装；
* 视图层的交互响应者：所有的交互都会传递给ViewModel，ViewModel会依次更新视图层需要的属性，同时相应修改model层的数据。不过这里最好依赖响应式架构或属性观察器；

#### MVP
MVP是在MVC的基础上，将Controller职责分离开，用它处理View的交互事件、数据绑定等。MVP与MVC的相同点是Model层都是一样的，但是MVP的V是表示UIView和UIController。View层持有Presenter作为变量，当接收到用户交互时，它会调用Presenter进行处理，也就是说View层不包含任何业务逻辑，它只会将交互交给Presenter，并从Presenter接受结果来更新自己。
Presenter被用来沟通View和Model之间的联系，Model不能直接作用于View的更新，只能通过Presenter来通知View进行视图刷新，所以View就只专注于视图相关内容，被动接收Presenter的命令。这样的话，View就只显示，不处理逻辑，Presenter持有Model，Model只用于处理数据相关内容；
但是Presenter需要注意循环引用的问题。
* 缺点：
	* 所有的交互都传给Presenter处理，从而一旦项目功能增加了，View的代码和Presenter的代码都增加了。维护成本就特别高昂；

#### MVC & MVVM & MVP
* 三种架构的Model层基本相同；
* 视图层理论上都被设计成被动，但是实际略有不同：
	* 理论上MVC希望视图只负责UI更新和交互，不涉及业务逻辑和模型更新；但是实际开发中，MVP和MVVM的视图层反而实现了这个期望，即与中间层严格分离。
	* MVP的视图层是完全被动的，只单纯地把交互和更新传递给中间层；
	* MVVM的视图层并不是完全被动，它会监视中间层的变化，一旦发生变化，视图层也会相应发生变化；
* 中间层的设计是三种架构的核心差异：
	* MVC中的Controller持有视图和模型层，起到组装和桥接作用；
	* MVP的Presenter持有模型，在model的更新上和Controller角色一样，然后MVP的视图层持有Presenter。中间层的工作流程就是：从视图接收交互传递——响应——向视图层传递响应指令——视图更新；
	* MVVM：ViewModel持有模型，在更新模型上与前两者一致。它完全独立于视图，视图拥有中间层，通过绑定属性自动进行更新。
	
#### VIPER
VIPER由5个部分组成：View、Interactor、Presenter、Entity、Router。
* View：视图层，与MVP等的VIew一致，只接收用户交互信息但不处理，而是传递给展示层；
* Presenter：展示层，与MVP的P或MVVM的VM功能类似。这里的Presenter只响应并处理视图层传来的交互请求，并不直接对数据源进行修改。若要修改数据，需要向数据管理层Interactor发送请求；
* Router：路由，专门负责页面跳转和组件切换；
* Interactor：专门负责数据源信息，包括网络请求、数据传输、缓存、存储、生成实例等；
* Entity：模型层，与MVP等的Model大同小异；

VIPER在代码分配、测试覆盖率上为所有架构之冠。缺点就是由于分工精细，不同层级之间交互的代码太多，总体代码量很大。

#### 模块化、组件化：路由化
##### 模块化
项目的整体架构不止是MVC、MVP这种代码层面的东西，而应该是更高维度的规划。比如说对项目进行分层，分层的意义在意是项目模块化。从底层到上层一次是：独立于APP的通用层、通用业务层、中间层、业务层：
* 独立于APP的通用层：这一层主要是放一些跟APP耦合不是很大的模块，比如我们BT学院的BTCore模块，包括网络请求封装模块、各种category、自定义的一些UI组件等；
* 通用业务层：这个则是针对APP的一些基础模块，比如iPad分屏适配相关、接口请求通用处理及日志相关、APP中多个业务模块用到的一些通用组件等；它主要是给各个业务层提供一些通用的业务类代码，比如BT学院的Loading、日志、测试工具、缓存等；
* 中台：中台的作用则是协议各个业务层的通信，同时让业务与业务之间解耦；比如BT学院的各个Router；
* 业务层：则是各个单独的业务模块。比如BT学院的题库、问答、学习等；

模块化的优势：各模块直接代码和资源相互独立，模块可以独立维护、测试等。实现简单的插拔式。
其次模块化：主要是有两个方式：
1、通过cocoapod的方案将各个主代码模块打包成pod包的形式。然后通过配置podsepc来进行模块以及库直接的依赖。但是会存在一些问题：
	* 文件夹只有一层，没法做分级；
	* 库循环依赖问题；
	* 图片资源管理问题；
	* 每次修改完都得pod install一下；
	* 多人同时修改pod库，容易出现冲突；

   2、使用cocoa touch framework。主要注意的点是混编时，对外的头文件，尤其是swift中使用到的OC头文件放到public中，因为framework不支持bridge；framework中的内核架构

我们模块化的具体实施则是由develop pod的方式进行的。

##### 组件化
组件可以分为基础组件、业务组件：

* 我们可以认为由一个或多个类构成，能够完整描述一个业务场景，并能被其他业务场景复用的功能单位叫做组件。

* 基础组件：比如各种三方库，自己封装的库，自己二次封装的库，业务开发时单独功能的UI框架，比如相册取照片、视频播放器等。
* 业务组件：业务也可以搞成单独的组件，使用pod来进行管理。 
这些可以独立出来的都可以算是组件，部分大小；
##### 组件通信
组件通信是中间层的主要内容，是为了解耦各个组件的。
组件通信方案一般有三种：

* URL Router：
  在前端，一个url表示一个web页面，在后端，一个url也表示一个接口请求；在iOS中，也会使用官方提供url去打开一个系统设置。所以同样的，
	* 对于带UI属性的独立模块，我们可以使用url来标记一个Controller；不仅方便本地跳转，还能支撑Server下发跳转指令。但是，它也存在一定局限性，
	* （问题）比如url里面无法拼接UIImage这种数据。(解决方案可以使用Memory Cache或Disk cache做中转)。
	* （不适合）不具备UI场景，比如日志模块。这类业务要使用URL开启就会感觉特别别扭，不如直接使用API来的直接。
	* （不适合）模块与具体的业务场景无关，比如Database模块，或者ToolKit、network这类就更不适合用URL的方式接入，反而更适合直接作为SDK来使用。
  蘑菇街的MGJRoutre就是使用这种方案，它在启动时候有个模块初始化的一个过程，初始化时需要注册各种服务（url和handle），使用的时候通过传入的URL来找到对应的handle，然后逻辑在handle里进行处理。具体做法：在MGJRouter的基础之上封装了一个BTRouter，里面自己定制一些参数处理的操作，将不同的参数尽可能扁平化。然后handler里执行逻辑处理与跳转，最后将结果通过block返回。
```
注册路由
[[Router sharedInstance] registerURL:@"myapp://good/detail" with:^UIViewController *{
     return [GoodDetailViewController new];
}];
通过url获取
UIViewController *vc = [[Router sharedInstance] openURL:@"myapp://good/detail"]
```
它使用一个全局的来管理对应的key和value，key是url，value是对应的对象。获取到对象后进行处理

* 缺点
  * 每个组件都需要一个表来维护它注册的服务，比较繁琐（内存使用倒是无可厚非，属于常规使用，在合理范围内）;
  * 参数的格式不明确，是个灵活的 dictionary，也需要有个地方可以查参数格式；
  * 可能需要用一个表或web文档来整理所有的url及参数。尤其是对于从h5或服务器通知发出的服务；
  * 以及上诉两种不适合的运用场景；

* Target Action：
这种方式则主要是利用iOS的反射机制，通过NSClassFromString来生成target类，然后再通过Runtime或者performSelector执行target的action，在action中进行目标类的实例化操作。利用这种机制，可以将任意类的实例化过程封装到任意一个target中，相比于URL Router，它无需注册和内存占用，缺点就是编译阶段是无法发现潜在的问题，对命名规则就更严格。
这种方案的开源框架就是CTMediador。

<https://juejin.im/post/5ccfd378e51d453b6c1d9cf5>
[组件间通信](https://juejin.im/entry/5baaf45cf265da0afb334b25)
[组件化及其通讯方案](https://juejin.im/entry/5baaf45cf265da0afb334b25)

* 面试题：组件化有什么好处，两个组件通信如何协议解耦？

### 图片与SDWebImage
#### 图片缓存架构设计：
##### 图片格式：
* png
	png是图片无损压缩格式，支持alpha通道；
* jpeg
	jpeg是图片有损压缩格式，可以指定0~100的压缩比；
	

所以如果要设置透明度就得使用png，如果不在乎质量，要节省内存，则使用jpeg。

##### iOS图片加载方式：
iOS 提供了UIImage用来加载图片，提供了UIImageView用来显示图片；
* imageNamed
	可以缓存已经加载的图片。使用时会根据文件名在系统缓存中寻找图片，如果找到了就返回，如果没有找到就在Bundle内查找文件名，找到后将其放到UIImage里返回，**并没有进行实际的文件读取和解码，当UIImage第一次显示到屏幕上时，其内部解码方法才会被调用，同时解码结果会保存到一个全局的缓存中**。这个全局缓存会在APP第一次退到后台和收到内存警告时才会被清空。
* imageWithContentsOfFile
	方法则是直接返回图片，不会进行缓存。但是其解码依然要等到第一次显示该图片的时候；

##### 什么是图片解码
在UI的显示原理中，CALayer负责显示和动画操作相关内容，其中CALayer的属性contents是对应一张CGImageRef的位图。**位图**实际上就是一个像素数组，数组中的每个像素就代码图片中的一个点。**Image Buffer**就是内存中用来存储位图像素数据的区域；**Data Buffer**就是用来存储JPEG、PNG格式图片的元数据，对应着源图片在磁盘中的大小；
**解码就是将将不同格式的图片转码成图片的原始像素数据（ImageRef），然后绘制到屏幕上**。
UIImage就负责解压Data Buffer内容并申请Image Buffer存储解压后的图片信息；
UIImageView就负责将Image Buffer拷贝至frame Buffer(帧缓存区)，用于屏幕上显示；

```
ImageBuffer按照每个像素RGBA四个字节大小，一张1080p的图片解码后的位图大小是1920 * 1080 * 4 / 1024 / 1024，约7.9mb，而原图假设是jpg，压缩比1比20，大约350kb，可见解码后的内存占用是相当大的。
```

##### 开始一步步搭建缓存框架
TODO：
https://juejin.im/post/6844903807667666951
* 单纯的图片下载非常简单，使用URLSession进行下载，然后使用imageWithData生成Image，最后回到主线程显示出来；


#### 图片相关优化
##### 降低采样率(DownSampling)
在视图比较小，但是图片缺较大的场景下，直接显示原图会造成不必要的内存和CPU消耗。这里就可以使用ImageIO的接口，DownSampling，也就是生成缩略图
```
	// 获取缩略图
    func downSample(imageAt url:URL, to size:CGSize, scale:CGFloat) -> UIImage {
        //避免缓存解码后的数据，因为这个是缩略图，之后的使用场景可能就不一样，所以不要做缓存。
        let imageSourceOptions = [kCGImageSourceShouldCache : false] as CFDictionary
        let imgSource = CGImageSourceCreateWithURL(url as CFURL,imageSourceOptions)!
        
        let maxDimendionInPixels = max(size.width,size.height) * scale
        //kCGImageSourceShouldCacheImmediately设为YES，则就立马解码，而不是等到渲染的时候才解码
        let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways : true,
                                 kCGImageSourceShouldCacheImmediately : true,
                                 kCGImageSourceCreateThumbnailWithTransform : true,
                                 kCGImageSourceThumbnailMaxPixelSize : maxDimendionInPixels] as CFDictionary
        let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imgSource,0,downsampleOptions)!
        return UIImage(cgImage:downsampledImage)
    }
```

##### 将解码过程放到异步线程
解码放在主线程一定会造成阻塞，所以应该放到异步线程。
iOS 10之后，UITableView和CollectionView都提供了一个预加载的接口:tableView( _ : prefetchRowsAt:) 提前为cell加载数据。

```
	let serailQueue = DispatchQueue(label: "decode queue")
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            serailQueue.async {
                let downSampledImg = "" //解码操作
                DispatchQueue.main.async {
                    self.update(at:index,with:downSampledImg)
                }
            }
        }
    }
    //这里使用串行队列，避免开启多个线程，因为线程消耗也是很大的
```
##### 平时UI代码注意的细节点
* 重写drawRect:UIView是通过CALayer创建FrameBuffer最后显示的。重写了drawRect，CALayer会创建一个backing store，然后在backing store中执行draw函数。而backing store默认大小与UIView大小成正比的。存在的问题：backing store的创建造成不必要的内存开销；UIImage的话先绘制到Backing store，再渲染到frameBuffer，中间多了一层内存拷贝；
* 更多使用Image Assets：更快地查找图片、运行时对内存管理也有优化；
* 使用离屏渲染的场景推荐使用UIGraphicsImageRender替代UIGraphicsBeginIMageContext，性能更高，并且支持广色域。
* 对于图片的实时处理，比如灰色值，这种最好推荐使用CoreImage框架，而不是使用CoreGraphics修改灰度值。因为CoreGraphics是由CPU进行处理，所以使用CoreImage交由GPU去做；

#### 正确的图片加载方式
类似SDWebImage流程
##### 下载图片主要流程：
* 1、从网络下载图片源数据，默认放入内存和磁盘缓存中；
* 2、异步解码，解码后的数据放入内存缓存中；
* 3、回调主线程渲染图片；
* 4、内部维护磁盘和内存的cache，支持设置定时过期清理，设置内存cache的上限等，对不同的图片设置不同的缓存大小。比如常用的0~100kb的图片设置100张，100~500kb设置50张，500~1m设置10张，超过1m不进行内存缓存。
##### 加载图片流程简化：
* 1、从内存中查找数据，如果有，并且已经解码，直接返回数据，如果没有解码，异步解码缓存内存后返回；
* 2、内存中未查找到图片数据，从磁盘查找，磁盘查找到后，加载图片源数据到内存，异步解码缓存内存后返回，如果没有去网络下载图片，走上面的流程；

总结：这个流程就主要避免了在主线程中解码图片的问题；然后通过缓存内存的方式，避免了频繁的磁盘IO；缓存解码后的图片数据，避开了频繁解码的CPU消耗；

#### 超大图片处理
如果是非常大的图，比如1902 * 1080，那解码之后的大小就达到了近7.9mb。像上述的图片加载方案或者SDWebImage的加载方式，默认就会自动解码缓存，那么如果有连续多张的情况，那内存将瞬间暴涨，甚至闪退。
那解决方案就分为两个场景：
* 如果显示的UIView较小，则应该通过上述降低采样率的方式，加载缩略图；
* 如果是那种像微信、微博详情那样的大图，则应该全屏加载大图，通过拖动来查看不同位置图片的细节。技术细节就是使用苹果的CATiledLayer去加载，它可以分片渲染，滑动时通过映射原图指定位置的部分图片数据解码渲染。



#### 面试题
* 图片占用内存由什么决定？描述图片从磁盘加载到内存再展示发生了几次copy，SDWebImage对这次copy做了哪些优化？
* 图片从加载到展示全流程描述？
* UIImageView加载有哪些方法，分别什么特点，imageWithName加载图片的时候，解码发送在什么时候
* jpg和png加载到内存中后有什么区别
* 圆角、阴影、光栅化为什么造成卡顿，怎么解决？

[iOS图像最佳实践](<https://juejin.im/post/5c84bd676fb9a049e702ecd8>)
[周小可—图片的编码与解码](https://hnxczk.github.io/blog/articles/image_decode.html#imagewithcontentsoffile)

[image/io](<https://zhuanlan.zhihu.com/p/30591648>)

[图片渲染相关](<https://lision.me/ios-rendering-process/>)

[ios绘制](<https://segmentfault.com/a/1190000000390012>)



#### SDWebImage源码细节：

##### 源码架构与基础流程
* 架构简述：
  SDWebImage是通过给UIImageView写的一个分类：UIImageView + WebCache；而支撑整个框架的核心类是SDWebImageManager。它通过管理SDWebImageDownloader和SDImageCache来协调异步下载和图片缓存。

* 流程 基于4.3版本，5.0之后的版本改成了面向协议的方式，但是主要流程和类还是没什么大的改变的
```
1、入口函数会先把placeholderImage显示，然后根据URL开始处理下载;
2、进入下载流程后会先使用url作为key值去缓存中查找图片，如果内存中已经有图片，则回调返回展示（这里就不会再管磁盘有没有的情况了）;
3、如果没有找到，则会生成一个Operation进行磁盘异步查找，如果找到了会进行异步解码，解码完成后将结果回调，同时会同步到缓存中去。
4、如果没有在本地找到，则会生成一个自定义的Operation开启异步下载。
5、下载完成后，将下载的结果进行解码处理，然后返回。同时将图片保存到内存和磁盘。
```

[SDWebImage原理](<https://zhuanlan.zhihu.com/p/64934706>)
[周小可—SDWebImage源码解析](<https://hnxczk.github.io/blog/articles/sd.html#sdwebimagecache>)

##### 注意的细节与常考点，与上述流程对应
* 第1步中：会先设置placeholder。然后根据URL开启下载。整个库中的key值默认使用图片URL，比如缓存、下载操作等。URL中可能会含有一部分动态变化的部分（比如获取权限的部分），所以我们可以取url不变的值scheme、host、path作为key值；
* 第2、3步中：首先会判断是否只使用了内存查找，如果是的话，则不进行磁盘查找，也不将查找的图片存到磁盘；否的话会先生成一个NSOperation赋值给SDWebImageCombinedOperation的cacheOperation，用于cancel。然后会封装一个block来执行磁盘查找，block根据设置来确实是同步还是异步查找，如果是异步查找的话，会放到一个串行的IO队列中。在查找期间会先判断Operation是否取消，如果已经取消则不进行查找。查找的过程中会创建一个@autoreleasePool用来及时释放内存；如果在磁盘中找到了data，那么会将data解码成Image,并同时存一份到内存中，如果内存空间过小，则会先清一波内存缓存；
* 第4步中：1、每张图片的下载是由自定义的NSOperation的子类进行的，它实现了start方法。start方法中创建了一个NSURLSession开启下载，使用了RunLoop来确保从start到结果响应期间不会被干掉，如果运行后台下载的话，也是在这里进行处理的。2、Operation被放到一个NSOperationQueue中并发执行，队列中的最大并发量是6；DownloadQueue使用了信号量来确保线程安全；3、每个Operation、结果回调block、进度block都是包装存储到一个URLCallBack中的，它以url为key值缓存在一个NSMutableDictionary的字典中，以便cancel及其他操作。但是因为可能存在多个操作同时进行的情况，所以这里就使用了dispatch_barrier来确保NSMutableDictionary的线程安全；4、下载过程中，如果返回了304 not Modified，则表示客户端是有缓存的，则可以直接cancel掉Operation，返回回调返回缓存的image。
* 第5步：下载完成后，会在URLSessionTaskDelegate的回调方法里使用一个串行队列异步进对下载图片进行解码。解压完成后，如果是JPEG这种可压缩格式的图片则会按照设置进行压缩后再返回。如果有缩略设置，也会对图片进行缩放等；
* 其他：
  * SDWebImageCombinedOperation：它实际上不是一个NSOperation，它只是持有了downloadOperation和cacheOperation（真实的NSOperation类型），downloadOpetation对应着SDWebImageDownloadToken类型，它包含着一个SDWebImageDownloaderOperation和url，也就是URLSession的实际下载操作；

  * 内存缓存使用的是NSCache的子类。NSCache是类似NDDictionary的容器，它是线程安全的，所以在任意线程进行添加、删除都不需要加锁，而且在内存紧张时会自动释放一些对象，存储对象时也不会对key值进行copy操作。SDImageCache在收到内存警告或退到后台的时候会清理内存缓存，应用结束时会清理过期一周的图片；内存缓存是缓存解码之后的图片，也就是UIImage。

  * 磁盘缓存使用的是NSFileManager来实现的。图片存储的位置位于Cache文件夹，文件名是对key值进行MD5后的值，SDImageCache定义了一个串行队列来对图片进行异步写操作，不会对主线程造成影响；存到磁盘的同时会检查是jpeg还是png（这里主要是通过alpha通道来判断的），然后将其转成对应的压缩格式进行存储；读取磁盘缓存也会先从沙盒中读取，然后再从bundle中读取，读取成功后才进行转换，转换过程中先转成image，然后根据设备进行@2x、@3x缩放，如果需要解压缩再解压缩，之后才是后续解码操作。

  * 清理磁盘缓存可以选择全部清空和部分清空。全部清空则是把缓存文件夹删除，部分清空会根据参数设置来判断，主要看文件缓存有效期和最大缓存空间，文件默认有效期是1周；文件默认缓存空间大小是0，也就是表示可以随意存储，如果设置了的话，则会先判断总大小是否已经超出最大值，如果超出了，则优先保留最近最先使用的图片，递归删掉其他过早的图片，直到总大小小于最大值。

  * 使用主队列来代替是否在主线程的判断；

  * 后台下载：使用`-[UIApplication beginBackgroundTaskWithExpirationHandler:]` 方法使 app 退到后台时还能继续执行任务, 不再执行后台任务时，需要调用 `-[UIApplication endBackgroundTask:]` 方法标记后台任务结束

  * 框架中使用最多的锁是dispatch_semaphore_t，其次是@synchronized互斥锁；



[SDWebImage相关面试题](http://cloverkim.com/SDWebImage-interview-question.html)

[SDWebImage源码阅读笔记](https://www.jianshu.com/p/06f0265c22eb)



### 播放器 与 音视频相关
#### 基础类
* NSURL 支持 本地文件url 和 网络的url
* AVPlayerItem 通过 URL 初始化的一个播放对象（状态获取）
* AVPlayer 通过 AVPlayerItem 初始化的播放控制器（控制）
* AVPlayerLayer 通过 AVPlayer初始化的一个播放展示视图（展示）

#### AVPlayerItem的各种需要监听的状态
* 通过监听“status”字段来监听播放状态，主要存在三种状态：.unknown、.readyToPlay、.failed。如果是.readyToPlay状态，则可以获得播放时长、视频大小、视频首帧等信息；
* 通过监听"loadedTimeRanges"字段来监听缓冲大小；
* 通过监听"playbackBufferEmpty"字段表示缓冲区空了，需要加载；
* 通过监听"playbackLikelyToKeepUp"来表示缓冲区满了。

##### 视频首帧获取
```
// 获取视频第一帧
-(UIImage*)getVideoPreView{
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:self.playerItem.asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}
```




https://juejin.im/post/5da1a30de51d457825210a8c

### 直播框架与实践
#### 移动端主要框架
移动端直播框架就主要分为主播端和观看端。
* 主播端：
	* 音视频采集：AVFoundation；
	* 视频处理(美颜、水印)：GPUImage；
	* 音视频编码压缩：音频压缩FFmpeg，视频压缩：x264；
	* 封装音视频后进行推流：libremp框架；
* 观看端：
	* 音视频解码：FFmpeg视频解码，VideoToolBox视频硬解码，AudioToolBox音频硬解码；
	* 播放：ijkplayer；
* IM聊天：聊天室、点亮、推送、超过、黑名单、聊天信息、滚动弹幕等；
* 礼物相关：各种礼物、红包、排行榜等；

#### 主要是对业务层的搭建
直播端业务逻辑倒是不是特别复杂，大部分可以直接使用MVC框架即可。主控制器的独立业务太多的话，可以拆分成多个单独的Category；对于Model的数据变化可以采用notification的形式通知，便于做多处绑定；然后对于各种类型消息可以使用面向协议的方式编写；
礼物：要使用队列存储礼物；
消息：聊天消息要注意高度计算及卡顿相关问题，然后各种消息的分发也应该使用队列的形式；
弹幕：也要用队列存储弹幕，同时要限制条数；
聊天室：聊天室的各种消息类型比较多，尤其是频繁进出房间的时候。导致客户端与服务端之间的消息过多，可能就会产生一些性能问题，可以考虑在用户过多的情况下不发送进出房间消息，或者根据用户优先级来确定是否发送进出房的同步消息；

#### 直播协议比较：
* HLS：苹果退出的流媒体技术，是以点播的技术方式来实现直播，使用HTTP短链接。优势：兼容性、性能和、穿墙和HTTP一样；劣势：高延时、文件碎片；
* RTMP：实时消息传送协议，TCP长连接，端口1935，有可能会被墙掉，低延时。
HLS与RTMP对比: HLS主要是延时比较大，RTMP主要优势在于延时低HLS协议的小切片方式会生成大量的文件，存储或处理这些文件会造成大量资源浪费，相比使用RTSP协议的好处在于，一旦切分完成，之后的分发过程完全不需要额外使用任何专门软件，普通的网络服务器即可，大大降低了CDN边缘服务器的配置要求，可以使用任何现成的CDN,而一般服务器很少支持RTSP。

#### 直播关键性能指标
* 直播为什么会卡顿？
	* 关键词：**帧率**FPS和APP刷新帧率是一个概念，表示每秒显示的图片数，**码率**：图片进行压缩后每秒显示的数据量,码率主要用于推流和拉流，跟网速有关。
	* 推流帧率太低：如果主播端手机性能较差，或者很占CPU的后台程序在运行，可能导致视频帧率太低。正常情况下FPS达到每秒15帧以上才能保证观看端的流畅度，如果FPS低于10帧，可以判定是**帧率太低**，则全部观众体验都会卡顿;
	* 上传阻塞：主播端在推流时会源源不断产生音视频数据，如果手机上传网速太小，那么音视频数据就会堆积在手机里传不出去，导致全部观众体验卡顿；
	* 下行不佳：观众端带宽不足，比如直播流的码率是2Mbps，也就是每秒2M数据要下载，下行带宽不够那么就会影响当前用户卡顿。
	
* 解决方案：
	* 查看当前推流SDK的CPU的占用情况和当前系统的CPU占用情况；如果当前系统占用率超过80%，那么采集和编码都会受到影响。所以要找到直播之外的CPU消耗情况，进行优化；
	*  不要盲目追求高分辨率：较高的视频分辨率如果没有较高的码率，则就无法带来好的体验，所以要根据网络情况选择分辨率。
	*  有的SDK，如果发现APP的CPU使用率过高，则会切到硬编码来降低CPU的使用率，比如腾讯SDK。
	*  上传阻塞的解决方案：使用更好的网络；使用合理的编码设置，比如低分辨率；
	*  下行不加：卡顿延迟，因为由于网络不行，所以可能就拿不到足够的数据，所以可以考虑让APP缓存到足够的数据后再播放，不过这个会导致高延时，而且播放时间越久就越延时，HLS就是通过引入延时20~30秒来实现流畅的播放体验；腾讯SDK提供了多种延时控制方案：自动模式————会根据网络情况自动调节延迟大小；极速模式————高互动的秀场直播，就是在不卡顿的情况下，将延时调节到最低；流畅模式————适用于游戏直播，会在出现卡顿的时候loading知道缓冲区蓄满；

重要[腾讯直播SDK](https://cloud.tencent.com/document/product/454/7946)

[袁峥如何快速开发一个完整的iOS直播APP]https://www.jianshu.com/p/bd42bacbe4cc
[研发直播APP的收获](https://www.jianshu.com/p/d99e83cab39a)
[开发直播APP中要了解的原理](https://juejin.im/entry/58a6f725128fe100647cff29)



### 下载模块与AFNetWorking

#### 下载框架

首先需要一个manager管理整个app的下载事件；它负责管理每一个request。比如说取消、重新加载等操作。其次需要有一个Config配置类，用来配置基础信息，比如配置请求类型、cookie、时间等信息。然后有一个对response进行处理的工具，比如日志的筛选打印、对一些异常错误的处理等等

#### AFNetworking

整体框架：AFNetWorking整体框架主要是由会话模块(NSURLSession)、网络监听模块、网络安全模块、请求序列化和响应序列化的封装以及UIKit的集成模块(比如原生分类)。
其中最核心类是AFURLSessionManager，其子类AFHTTPSessionManager包含了AFURLRequestionSerialzation(请求序列化)、AFURLResponseSerialzation(响应序列化)两部分；同时AFURLSessionManager还包含了NSURLSession(会话模块)、AFsecurityPolicy(网络安全模块：证书校验)、AFNetWorkingReachabilityManager(负责对网络连接进行监听)；
AFURLSessionManager主要工作包括哪些？
1、负责管理和创建NSURLSession、NSURLSessionTask
2、实现NSURLSessionDelegate等协议的代理方法
3、引入AFSecurityPolicy保证请求安全
4、引入AFNetWorkingReachabilityManager监听网络状态
https://www.jianshu.com/p/b3c209f6a709
#### Alamofire：同一个作者写的swift版本的AFNetWorking

整体框架：Alamofire核心部分都在其Core文件夹内，它包含了核心的2个类、3个枚举、2个结构体；另一个文件夹Feature则包含了对这些核心数据结构的扩展。
2个类：Manager(提供对外接口，处理NSURLSession的代理方法)；Request(对请求的处理)；
3枚举：Method(请求方法)；ParameterEncoding(编码方式)；Result(请求成功或失败数据结构)
2结构体：Response(响应结构体)；Error(错误对象)
扩展中包括Manager的Upload、Download、Stream扩展、以及Request的扩展Validation和ResponseSerialization。
怎么处理多并发请求？
使用NSOperetionQueue！



[AFNetWork图片解码相关]<https://www.jianshu.com/p/90558187932f>



### AsyncDisplayKit：
整体框架：
正常情况下，UIView作为CALayer的delegate，而CALayer作为UIView的一个成员变量，负责视图展示工作。ASDK则是在此之上封装了一个ASNod类，它有点view的成员变量，可以生成一个UIView，同时UIView有一个.node成员属性，可以获取到它所对应的Node。而ASNode是线程安全的，它可以放到后台线程创建和修改。所以平时我们对UIView的一些相关修改就可以落地到对ASNode的属性的修改和提交，同时模仿Core Animation提交setneeddisplayer的这种形式把对ASNode的修改进行封装提交到一个全局容器中，然后监听runloop的beforewaiting的通知，当runloop进入休眠时，ASDK则可以从全局容器中把ASNode提取出来，然后把对应的属性设置一次性设置给UIView。

主要解决的问题：布局的耗时运算(文本宽高、视图布局运算)、渲染(文本渲染、图片解码、图形绘制)、UIKit的对象处理(对象创建、对象调整、对象销毁)。因为这些对象基本都是在UIKit和Core Animation框架下，而UIKit和Core Animation相关操作必须在主线程中进行。所以ASDK的任务就是把这些任务从主线挪走，挪不走的就尽量优化。





### IM
* IM中信息的可靠性传输：消息不丢失、消息不重复；
  首先我们大概看一下消息的发送流程：
  * 步骤1：用户A发送信息到达IM服务器；
  * 步骤2：服务器进行消息暂存；
  * 步骤3：暂存成功后，将成功的消息返回给A；
  * 步骤4：返回确认消息的同时将消息推送给用户B；
  这些步骤中1~3步任一失败的话，用户A会被提示发送失败。后面步骤中，可能出现消息未能推送给B导致失败，也可能出现B写入本地数据库失败导致消息丢失。
  解决方案：
  基本原理就是：ACK确认机制+消息重传+消息完整性校验，来解决消息丢失的问题。
  ACK确认机制就是TCP的ACK确认回复，在三次握手、四次挥手中都有使用到。首先TCP报文字节都是有数据序列号的。ACK报文每次回复确认都会带上序列号，告诉发送方接收到了哪些数据，所以这也保证了消息的有序性。然后如果ACK确认报文丢失，那么可能是发送数据丢失位到底IM服务器，也可能是到底了服务器，但是返回的确认报文丢失了。无论是这两种的那种情况，TCP都可以使用超时重传的策略解决，只是如果是ACK确认丢失了，则服务器会先忽略掉新的数据，然后发送ACK应答。其次IM业务层也基本参考了ACK确认机制和超时重传机制。比如推送消息给B时，会携带一个标识，然后将退出去的消息添加到“待ACK确认消息队列”，用户B收到消息后会回复一条ACK包，然后服务器把消息从待确认队列中删除。否则进行重新推送。之所以要加业务层的ACK确认机制，是因为TCP只能保证传输层的消息是否到底，但是业务层可能到底之后还需要进行处理，比如说存入本地数据库。
  消息完整性校验：则是可以通过每一条消息带上时间戳的形式，然后每次重连后对比时间戳，则可以知道大概哪些消息没有到达，然后将待确认队列的时间戳之后的数据都按序发送一遍。
  如何确保消息不重复？
  同样是给每个消息带上一个ID，接收方接到消息后，先进行业务去重，然后才考虑是否使用这个消息。

* IM数据库如何设计表
	* 会话表：用于存储所有会话。
	* 聊天详情表：主要用于存储消息
	* 群组表：存储每个群组相关数据
	* 群组信息表：用于关联群组表和群成员表
	* 群成员表：存储群成员信息
	* 联系人表：存储所有联系人。


### 单元测试与可持续集成

<https://juejin.im/post/5a3090f2f265da4310485d01>

[桂林 单元测试](<https://github.com/codingingBoy/codingingBoy.github.io/blob/master/_posts/2017-11-23-iOS-UI%E8%87%AA%E5%8A%A8%E5%8C%96%E6%B5%8B%E8%AF%95.md>)

### Swift Package Manager

<https://www.jianshu.com/p/479986e9ae80>

### 进程间通信



### 敏捷开发

https://juejin.im/post/6844904039822409735#heading-3



### APP 相关
#### APP 证书
* 苹果如何保证iOS系统只安装苹果的软件？

#### APP如何与后台进行通信
