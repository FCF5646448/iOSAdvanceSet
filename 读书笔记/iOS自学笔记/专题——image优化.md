---
title: iOS-技能知识小集
date: 2020-10-12 17:36:48
tags: image
categories: iOS进阶
description: 本章节主要讲究图片基础知识以及开发过程中对图片的一些处理相关学习。
---

### Image优化
#### 图片存在的问题：

一是内存问题。我们平时接触到的jpeg、png格式都是图片压缩格式，之所以要使用图片压缩格式，是因为未经压缩的原始像素数据都是非常占内存的。

二是解码问题。解码过程会占用大量CPU。而且系统默认的是在主线程进行解码操作，所以依然容易造成主线程卡顿的问题。

#### 图片显示原理
图片显示的过程主要分为3个步骤：

* **加载**图片（load）：

  通常我们使用 “imageNamed + 图片名称” 加载图片，首先都是通过图片名称从Asset或者Bundle或者磁盘当中查找图片，找到图片后加载进UIImage里面。

  * imageNamed 和 imageWithContentsOfFile的区别就是：通过imageNamed加载的图片，解码完成后会将结果保存到一个全局的缓存中。这个全局缓存会在APP第一次退到后台或收到内存警告时被清空。

* **解码**图片（decode）：

  图片在加载进UIImage后，不会立即进行解码操作，而是在图片第一次显示到屏幕上时，才调用内部的解码方法进行解码操作。**解码就是将不同压缩格式的图片转码成图片的原始像素数据的过程**。

* **渲染**图片（render）：

  解码完成后，图片才会被赋值给UIImageView的图层上，最终渲染到手机屏幕上。

从内存区域(Buffers)的角度，可以看成三种Buffer之间的转换：

* **Data Buffer**：

  Data Buffer是图片原始数据，可以理解为PNG、JPEG格式的图片，这种数据包含图片的拍摄时间、地点、所以不能直接用来描述图像像素信息。Data Buffer的大小其实就是磁盘里存储的图片大小。

  * png：**png是图片**无损压缩**格式，支持alpha通道**；png图片加载会比JPEG更长，因为文件可能更大，但是解码会相对更快，而且xcode会把png图片进行解码优化之后引入工程。
  * jpeg：**jpeg是图片**有损压缩**格式，可以指定0~100的压缩比**；jpeg图片更小，加载更快，但是jpeg解压算法更加复杂，所以解压要慢很多。

* **Image Buffer**：

  Image Buffer存储的就是图片解码后的像素数据，也就是我们常说的位图。也可以说**解码就是从data buffer生成Image Buffer的过程**。Image Buffer的大小与图片本身的大小成正比。
  ```
  解码之后的图片大小：
  ImageBuffer按照每个像素RGBA四个字节大小来显示。
  对于一张1920*1080的图片来说，解压解码后的位图大小是
  1920 * 1080 * 4 = 829440 bytes，约7.9mb！
  而原图假设是jpg，压缩比1比20，大约350kb，可见解码后的内存占用是相当大的。
  ```

* **Frame Buffer**：

  Frame Buffer就是帧缓存区。当视图层级发生变化时，UIKit会结合UIWindow和SubViews，渲染出一个frame buffer。然后显示到屏幕上。

#### 图片优化
##### 通过DownSampling (降低采样率)来优化内存

因为Image Buffer大大小跟图片本身大小成正比。所以如果UIImageView比较小，然后图片比较大的场景下。可以不用对整个图片进行解码，而是使用ImageIO的接口，来降低采样率（只显示一部分缩略图）。

```
func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
/*
kCGImageSourceShouldCache: 避免缓存解码后的数据，因为这个是缩略图，之后的使用场景可能就不一样，所以不要做缓存
kCGImageSourceShouldCacheImmediately: YES表示立马解码，而不是等到渲染的时候才解码
*/  
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions =
            [kCGImageSourceCreateThumbnailFromImageAlways: true,
             kCGImageSourceShouldCacheImmediately: true,
             kCGImageSourceCreateThumbnailWithTransform: true,
             kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        let downsampledImage =
            CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
        return UIImage(cgImage: downsampledImage)
    }
```

##### 预先在子线程中解码

因为解码操作默认是在主线程中进行，切是在图片显示前一刻才进行解码操作。所以，首先可以将解码操作放到子线程中进行：

```
-(void)image {
	// 子线程中进行，这里最好使用串行队列，避免线程切换的消耗
	dispatch_queue_t queue = dispatch_queue_create("xxx", DISPATCH_SERIALQUEUE);
    dispatch_async( &queue, ^{
        // 获取CGImage,本地使用：imageNamed:，远程使用：imageWithData:[NSdata dataWithContentOfURL:]。反正这步的目的就是将UIImage编程CGImage。
        CGImageRef cgImage = [UIImage imageNamed:@"xxx"].CGImage;
        
        //alpha
        CGImageAlphaInfo alphaInfo = CGImageGetAlaphaInfo(cgImage) & KCGBitmapAlaphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == KCGImageAlphaPremultipliedLast || 
        alphaInfo == KCGImageAlphaPremultipliedFirst || 
        alphaInfo == KCGImageAlphaLast || 
        alphaInfo == KCGImageAlphaLast ) {
            hasAlpha = YES;
        }
        
        //bitmapInfo
        CGitmapInfo bitmapInfo = kCGBitmapByteOrder32host;
        bitmapInfo |= hasAlph ?  kCGImageAlphaPremultiFirst : kCGImageAlphaNoneSkipFirst;
        
        //size
        size_t width = CGImageGetWith(cgimage);
        size_t height = CGImageGetHeight(cgimage);
        
        // context
        CGContextRef context = CGBitmapContextCreate(NULL,width,height,,0,CGColorSpaceCreateDeviceRGB,bitmapInfo);
        
        // draw
        CGContentDrawImage(context,CGRectMake(0,0,width,height),cgImage);
        
        // 获取image
        cgImage = CGbitmapContextCreateImage(context);
        
        UIImage *newImage = [UIImage imageWithCGImage: cgImage]；
        
        CGContextRelease(context);
        CGImageRelease(cgImage);
        
        dispatch_async(dispatch_get_main_queue(), ^{
        	self.imageView.image = newImage;
        });
        
    });
}
```

其次，可以提前对图片进行解码操作，并缓存，避免重复解码。

* 比如SDWebImage：

  * 当图片从网络中获取到的时候就立即进行解码，然后缓存到内存中；

  * 当图片从磁盘缓存中获取到的时候就立即进行解码，然后缓存到内存中；
    ```
    static const size_t kBytesPerPixel = 4;
    static const size_t kBitsPerComponent = 8;
    + (nullable UIImage *)decodedImageWithImage:(nullable UIImage *)image {
        if (![UIImage shouldDecodeImage:image]) {
        	return image;
        }
        //新建自动释放池，将bitmap context和临时变量都添加到池中在方法末尾自动释放以防止内存警告
        @autoreleasepool{
        	//获取传入的UIImage对应的CGImageRef（位图）
        	CGImageRef imageRef = image.CGImage;
        	//获取彩色空间
        	CGColorSpaceRef colorspaceRef = [UIImage colorSpaceForImageRef:imageRef];
        	//获取高和宽
        	size_t width = CGImageGetWidth(imageRef);
        	size_t height = CGImageGetHeight(imageRef);
        	// 每个像素占4个字节大小 共32位 (RGBA)
        	size_t bytesPerRow = kBytesPerPixel * width;
        	//初始化bitmap graphics context 上下文
        	CGContextRef context = CGBitmapContextCreate(NULL,width,height,kBitsPerComponent,bytesPerRow,colorspaceRef,kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
        	if (context == NULL) {
        		return image;
        	}
        	//将CGImageRef对象画到上面生成的上下文中，且将alpha通道移除
        	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        	//使用上下文创建位图
        	CGImageRef imageRefWithoutAlpha = CGBitmapContextCreateImage(context);
        	//从位图创建UIImage对象
        	UIImage *imageWithoutAlpha = [UIImage imageWithCGImage:imageRefWithoutAlpha scale:image.scale orientation:image.imageOrientation];
        	//释放CG对象
        	CGContextRelease(context);
        	CGImageRelease(imageRefWithoutAlpha);
        	return imageWithoutAlpha;
        }
        }
    ```

* iOS10之后，cell预加载数据API：tableView(_:prefetchRowsAt:) 可以实现对图片的预加载功能。

#### 其他注意事项：

##### 1、不要随意就执行提前解码的操作

因为图片解码后的大小与图片原始大小成正比，而提前解码的前提就是缓存。所以要根据实际情况来判断是否进行提前解码。

##### 2、降低峰值
在图片批量处理的过程中，使用AutoreleasePool来及时释放引用计数为0的对象
```
for image in images {
    @autorelease{
        operation()
    }
}
```

##### 3、 平时UI代码注意的细节点
* 重写drawRect:UIView是通过CALayer创建FrameBuffer最后显示的。重写了drawRect，CALayer会创建一个backing store，然后在backing store中执行draw函数。而backing store默认大小与UIView大小成正比的。存在的问题：backing store的创建造成不必要的内存开销；UIImage的话先绘制到Backing store，再渲染到frameBuffer，中间多了一层内存拷贝；
* 更多使用Image Assets：更快地查找图片、运行时对内存管理也有优化；
* 使用离屏渲染的场景推荐使用UIGraphicsImageRender替代UIGraphicsBeginIMageContext，性能更高，并且支持广色域。
* 对于图片的实时处理，比如灰色值，这种最好推荐使用CoreImage框架，而不是使用CoreGraphics修改灰度值。因为CoreGraphics是由CPU进行处理，所以使用CoreImage交由GPU去做；

##### 4、 超大图片处理
如果是非常大的图，比如1902 * 1080，那解码之后的大小就达到了近7.9mb。像上述的图片加载方案或者SDWebImage的加载方式，默认就会自动解码缓存，那么如果有连续多张的情况，那内存将瞬间暴涨，甚至闪退。
那解决方案就分为两个场景：

* 如果显示的UIView较小，则应该通过上述降低采样率的方式，加载缩略图；

* 如果是那种像微信、微博详情那样的大图，则应该全屏加载大图，通过拖动来查看不同位置图片的细节。技术细节就是使用苹果的CATiledLayer去加载，它可以分片渲染，滑动时通过映射原图指定位置的部分图片数据解码渲染。

##### 5、离屏渲染
* 定义：如果要在显示屏上显示内容，则就至少需要一块与屏幕像素数据量一样的frame buffer(帧缓存区)，作为像素数据存储区域，而这也是GPU存储渲染结果的地方。如果有时面临一些限制，无法把渲染结果直接写入frame buffer,而是先暂存在另外的内存区域，之后再写入frame buffer,那么这个过程被称之为**离屏渲染**; (打开xcode的离屏渲染开关，属于离屏渲染的区域会被标记为黄色)

* 并不是在frame buffer之外的内存区域进行渲染都是离屏渲染。比如通过drawRect，申请一块后备缓存进行绘画。这只能称作CPU的软件渲染。**真正的离屏渲染发送在GPU**。

* 为什么会发生离屏渲染？

  首先图层的渲染模块是交给一个叫做**Render Server**的独立进程来做的。这个Render Server是遵循**画家算法**来进行渲染的，具体来说就是按照视图的层级关系，一层一层渲染好输出到frame buffer，后一层覆盖前一层（相当于父视图渲染好输出到帧缓存中，然后子视图再渲染好，输出到帧缓存并覆盖到父视图上）。而且这种渲染方式无法在某一层渲染之后，再回过头来进行改动。这就意味着，所有添加到frame buffer的渲染结果必须一次性渲染完成，否则就得借助其它内存来临时完成更复杂、多次的渲染操作，然后再将结果回馈输出到frame buffer。

* 常见的离屏渲染常见
  * cornerRadius+clipsToBounds: 单独的一个layer切圆角是可以直接渲染出来的。但是视图容器里的子layer因为父视图有圆角，那么也需要被裁剪，而父视图渲染的时候，子视图是不知道的，也就是说子视图无法跟父视图一起被裁剪。 所以这就需要开辟独立空间，将当前视图以及其所有子视图一起渲染裁剪，最后再把结果反馈到frame buffer中。

  * shadow：阴影需要在本体被渲染完成之后才能渲染出来。而阴影layer是放在在本体下一层，也就是说优先本体渲染到frame buffer中。所以它也需要额外独立空间将阴影和本体都渲染完成后输出到frame buffer中。（所以，我们通常先使用shadowPath去单独设置阴影路径，然后结合其他layer来单独绘制阴影，这样就不会产生离屏渲染问题）

  * group opacity：group opacity是指给一组图层添加透明度。所以可想而知，是不可能一次性渲染完成的。得要所有相关图层都渲染完成，然后加上透明度，才能得到预期效果。所以这肯定也是需要额外开辟空间处理的；

  * mask：mask是应用在layer和其所有子leyer的组合之上的。所以它存在和group opacity一样的问题，不得不在离屏渲染中完成；

  * UIBlurEffect：也是应用到一组图层之上的。

* 离屏渲染为什么会影响性能？
  GPU的操作是高度流水化的。如果遇到不得不开辟另一块内存进行渲染操作的情况，则GPU就会终止当前流水线的工作，而切换到额外内存中进行渲染，之后再切回到当前屏幕缓冲区继续流水线工作。
  所以频繁的上下文切换是导致性能受影响的主要因素。(比如说cell，滚动的每一帧变化都会触发每个cell的重新绘制。因此一旦存在离屏渲染，那么这种上下文切换就会每秒发生60次，如果一帧画面不止一个图片，每个图片都存在离屏渲染，则切换次数将会更加可观)。
* 如何优化离屏渲染？
  * 1、利用CPU渲染避免离屏渲染。其实性能优化经常做的一种失去就是平衡CPU和GPU的负载，让它们尽量做自己最擅长的工作。比如文字(CoreText使用CoreGraphics渲染)和图片(ImageIO)渲染，则是由CPU进行处理，之后再将结果传给GPU。所以像给图片加圆角这种操作，就可以考虑用CPU渲染来完成。
  * 2、在离屏渲染无法避免的情况下，则想办法把性能影响降到最低。主要的优化思路就是：**将渲染出来的结果缓存起来**。CALayer提供了一个shouldRasterize。shouldRasterize设置为true，则Render Server就会强制把渲染结果(包括子layer、圆角、阴影、group opacity等)保存在一块内存中，这样在下一帧中就可以被复用，而不会再次触发离屏渲染。但是也需要注意一些细节：
    * shouldRasterise**总是会至少触发一次离屏渲染**，如果你的layer不会产生离屏渲染，切忌不要使用；

    * 离屏渲染缓存有空间上限，最多不超过屏幕总像素的2.5倍大小；

    * 一旦缓存超过100ms没有被使用，就会自动丢弃；

    * layer一旦打算变化(size、动画)，则缓存立即失效；

    * 如果layer子视图结构复杂，也可以打开shouldRasterise，把整个layer树绘制到一块缓存。

* 《即刻》app所做的离屏渲染优化
	* 即刻大量应用AsyncDisplayKit(Texture)作为主要渲染框架，对于文字和图片的异步渲染操作交由框架来处理。关于这方面可以看我之前的一些介绍
	* 对于图片的圆角，统一采用“precomposite”的策略，也就是不经由容器来做剪切，而是预先使用CoreGraphics为图片裁剪圆角
	* 对于视频的圆角，由于实时剪切非常消耗性能，我们会创建四个白色弧形的layer盖住四个角，从视觉上制造圆角的效果
	* 对于view的圆形边框，如果没有backgroundColor，可以放心使用cornerRadius来做
	* 对于所有的阴影，使用shadowPath来规避离屏渲染
	* 对于特殊形状的view，使用layer mask并打开shouldRasterize来对渲染结果进行缓存
	* 对于模糊效果，不采用系统提供的UIVisualEffect，而是另外实现模糊效果（CIGaussianBlur），并手动管理渲染结果 



##### 6、压缩、降低采样率与SDWebImage一起使用 （压缩也是解决内存过大的方案之一,SDWebImage 也提供了压缩算法）
```
__weak typeof(self) ws = self;
[SDWebImageManager sharedManager].imageCache.shouldCacheImagesInMemory = NO;
[self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
	//resizedCGImage需要修改成非url的缩放
	if (image) {
		UIImage *img=[self resizedCGImage:image];
		ws.image=img;
	}else{
		ws.image =[self resizedCGImage:placeholder];
	}
}];
```


#### 面试题
* 图片占用内存由什么决定？描述图片从磁盘加载到内存再展示发生了几次copy，SDWebImage对这次copy做了哪些优化？
* 图片从加载到展示全流程描述？
* UIImageView加载有哪些方法，分别什么特点，imageWithName加载图片的时候，解码发生在什么时候
* jpg和png加载到内存中后有什么区别
* 圆角、阴影、光栅化为什么造成卡顿，怎么解决？

[iOS图片内存优化指南](https://www.infoq.cn/article/4EFKmwjKxNPAtp5GUasX)
[iOS图像最佳实践](<https://juejin.im/post/5c84bd676fb9a049e702ecd8>)
[周小可—图片的编码与解码](https://hnxczk.github.io/blog/articles/image_decode.html#imagewithcontentsoffile)

[image/io](<https://zhuanlan.zhihu.com/p/30591648>)

[图片渲染相关](<https://lision.me/ios-rendering-process/>)

[ios绘制](<https://segmentfault.com/a/1190000000390012>)


[iOS图片编解码入门](https://zhuanlan.zhihu.com/p/30591648)

[iOS ImageIO介绍](https://developerdoc.com/quick-start/%E5%9B%BE%E7%89%87/iOS%E5%9B%BE%E7%89%87-ImageIO%E4%BB%8B%E7%BB%8D/)


### Core Graphic学习
[Core Graphic框架学习](https://www.jianshu.com/c/ad35684395a5)

[Core Graphics学习](https://juejin.im/post/6880774803553255432)

### GPUImage
[GPU源码解读](https://philm.gitbook.io/philm-ios-wiki/mei-zhou-yue-du/gpuimage-yuan-ma-jie-du-yi)
[落影GPUImage使用](https://www.jianshu.com/nb/4268718)

### OpenGL ES 入门
略

