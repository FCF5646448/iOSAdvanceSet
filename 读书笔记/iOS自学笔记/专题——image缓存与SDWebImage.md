---
title: iOS-技能知识小集
date: 2020-5-9 17:36:48
tags: image
categories: iOS进阶
description: 本章节主要是图片缓存架构相关学习。主要包含图片缓存架构的设计和SDWebImage源码的学习
---

### 图片缓存与SDWebImage

#### 图片缓存架构设计：
[从0打造一个iOS图片加载框架](https://juejin.im/post/6844903807667666951#heading-4)

[开始一步步搭建图片缓存框架](https://juejin.im/post/6844903807667666951)
这里的缓存，完全可以参照《专题——缓存框架》来做。然后结合下载逻辑一起。

* 单纯的图片下载非常简单，使用URLSession进行下载，然后使用imageWithData生成Image，最后回到主线程显示出来；

* 但是这样每次重新加载图片时，都需要重新下载，所以加入一个缓存，避免图片多次下载。我们使用一个**NSCache**来缓存已下载好的图片。然后再逻辑里，下载之前先去缓存里查看是否有对应图片，没有就下载，下载完成再次放到缓存里；

* 因为内存缓存只能局限于APP存活期，如果APP退出，缓存就会被销毁。下次进来还是要重新下载。所以再引入**磁盘缓存**。细节就是使用一个CacheManager专门负责缓存管理；然后缓存查找的时候，先查找内存，再查找磁盘，从磁盘找到后也缓存一份到内存。存入磁盘时，需要注意几点：
  * 存储位置；
  * 缓存的key——使用url做MD5加密处理；
  * 图片存储的时候，使用UIImagePNGRepresentation和UIImageJPEGRepresentation对png和jpeg两个格式转成Data，进行存储；
  * 对磁盘的读写非常耗时，所以使用一个自定义串行队列，然后将操作放到队列中，异步进行处理。
  * 内存使用NSCache会在内存紧张时自动回收，因此无需进行太多处理。**并且NSCache是线程安全的**。
  * 磁盘缓存可以控制文件保存的时间以及文件的总大小。maxAge:根据设置的存活时间计算出文件可保留的最早时间；遍历文件，进行时间对比；若文件被访问时间早于最早时间，删除对应文件。maxSize：遍历文件计算文件总大小；若文件大小超过限制大小，则按文件被访问时间进行排序；然后逐一删除文件，直到总大小小于限制大小的一半为止（删除到一半，是因为如果只删一点，那么可能很快又达到这个值，就得再次删除，而对文件的访问和删除都是非常耗性能的操作）。
  * 进一步优化的话可以考虑对不同的图片设置不同的缓存大小。比如常用的0~100kb的图片设置100张，100~500kb设置50张，500~1m设置10张，超过1m不进行内存缓存；
  * 磁盘大小和时间的检测时机，最好是监听到APP进入后台的时候去做。

* 最后下载完成后要优化成下载完成将图片同步一份到内存和磁盘中；下载完成后进行异步解码。

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

  * 内存缓存使用的是NSCache的子类。NSCache是类似NDDictionary的容器，它是**线程安全**的，所以在任意线程进行添加、删除都不需要加锁，而且在内存紧张时会自动释放一些对象，存储对象时也不会对key值进行copy操作。SDImageCache在收到内存警告或退到后台的时候会清理内存缓存，应用结束时会清理过期一周的图片；内存缓存是缓存解码之后的图片，也就是UIImage。

  * 磁盘缓存使用的是NSFileManager来实现的。图片存储的位置位于Cache文件夹，文件名是对key值进行MD5后的值，SDImageCache定义了一个串行队列来对图片进行异步写操作，不会对主线程造成影响；存到磁盘的同时会检查是jpeg还是png（这里主要是通过alpha通道来判断的），然后将其转成对应的压缩格式进行存储；读取磁盘缓存也会先从沙盒中读取，然后再从bundle中读取，读取成功后才进行转换，转换过程中先转成image，然后根据设备进行@2x、@3x缩放，如果需要解压缩再解压缩，之后才是后续解码操作。

  * 清理磁盘缓存可以选择全部清空和部分清空。全部清空则是把缓存文件夹删除，部分清空会根据参数设置来判断，主要看文件缓存有效期和最大缓存空间，文件默认有效期是1周；文件默认缓存空间大小是0，也就是表示可以随意存储，如果设置了的话，则会先判断总大小是否已经超出最大值，如果超出了，则优先保留最近最先使用的图片，递归删掉其他过早的图片，直到总大小小于最大值。

  * 使用主队列来代替是否在主线程的判断；

  * 后台下载：使用`-[UIApplication beginBackgroundTaskWithExpirationHandler:]` 方法使 app 退到后台时还能继续执行任务, 不再执行后台任务时，需要调用 `-[UIApplication endBackgroundTask:]` 方法标记后台任务结束

  * 框架中使用最多的锁是dispatch_semaphore_t，其次是@synchronized互斥锁；



[SDWebImage相关面试题](http://cloverkim.com/SDWebImage-interview-question.html)

[SDWebImage源码阅读笔记](https://www.jianshu.com/p/06f0265c22eb)