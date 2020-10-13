---
title: iOS-技能知识小集
date: 2020-10-12 17:36:48
tags: image
categories: iOS进阶
description: 本章节主要讲究图片基础知识以及开发过程中对图片的一些处理相关学习。
---

### 图片优化
图片存在的问题就是存储空间过大，图片展示越多，越占用内存空间，内存过高就容易导致很多问题。所以图片优化最主要的目的就是优化内存。

#### 内存过高的缺点
虽然现在iPhone设备的内存越来越高，不太会触发系统的阈值，而导致强杀。但是内存占用过高也会产生很多副作用。
* FOOM，内存过高超过阈值，导致被系统强杀；
* 如果一个APP占用过多内存，会导致系统杀掉其他APP来给当前APP提供足够的内存空间，导致体验不好；
* 当内存不足时，系统会将一部分Dirty Page压缩存储到磁盘中，当使用到这部分内存时，再从磁盘中读取回来，这样会造成CPU话费更多时间来等到IO，间接提供CPU占用率，也造成耗电。

#### 图片显示原理
图片其实是由很多像素点组成的，每个像素点描述了该点的颜色信息。这些颜色数据就可以直接渲染在屏幕上，成为**Image Buffer**。
而事实上由于图片源文件占用的存储空间过大，所以一般存储的时候都会进行压缩，常见的压缩格式就是JPEG和PNG。
* png：**png是图片**无损压缩**格式，支持alpha通道**；
* jpeg：**jpeg是图片**有损压缩**格式，可以指定0~100的压缩比**；

因此，当图片**存储在硬盘**中的时候，它是经过压缩的数据。经过解码后的数据才能用于渲染，因此图片渲染之前都需要先进行解码。解码后的数据就是**Image Buffer**。

* 解码：**解码就是将不同压缩格式的图片转码成图片的原始像素数据，然后绘制到屏幕上**；

具体的过程就是UIImage将Data Buffer数据解压成Image Buffer数据，UIImageView就负责将Image Buffer拷贝至frame Buffer(帧缓存区)，用于屏幕上显示。系统提供的图片加载方式：

* imageNamed：先根据文件名在系统缓存中进行查找，如果找到了就返回，如果没有找到就在Bundle内查找文件名，找到后将其放到UIImage里返回，但是此时**并没有进行实际的文件读取和解码，当UIImage第一次显示到屏幕上时，其内部解码方法才会被调用，同时解码结果会保存到一个全局的缓存中。这个全局缓存会在APP第一次退到后台和收到内存警告时才会被清空。**
* imageWithContentsOfFile：直接返回图片，不会进行缓存。但是**其解码依然要等到第一次显示该图片的时候**；

解码之后，图片在内存中的占用空间就是：
```
ImageBuffer按照每个像素RGBA四个字节大小来显示。
对于一张1920*1080的图片来说，解压解码后的位图大小是
 1920 * 1080 * 4 = 829440 bytes，约7.9mb！
 而原图假设是jpg，压缩比1比20，大约350kb，可见解码后的内存占用是相当大的。
```

#### 图片相关优化
##### 1、避免将图片放在内存里

不显示在屏幕上的图片，尽可能不要放在内存里。解码后的UIImage是非常大的，对于不需要显示的图片是不需要解码的。

##### 2、图片缩放
图片缩放最常见的处理方式，一般来说，是重新画一张小一点的图片。使用UIGraphicsBeginImageContextWithOptions函数：
```
extension UIImage {
    public func scaling(to size: CGSize) -> UIImage? {
        let drawScale = self.scale
        UIGraphicsBeginImageContextWithOptions(size, false, drawScale)
        let drawRect = CGRect(origin: .zero, size: size)
        draw(in: drawRect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
```
但是这个方式存在两个问题：
第一，默认是ARGB的格式，也就是说每个像素需要占用4个bytes空间，对于一些黑白或者仅有alpha通道的数据来说是没有必要的；
第二，原图解码时，会造成内存占用高峰。
对于问题一，可以使用新的UIGraphicsImageRender的方式，这个函数会自动选择对应的颜色格式，减少不必要的消耗：
```
extension UIImage{
	public func scaling(to size: CGSize) -> UIImage? {
        let render = UIGraphicsImageRenderer(bounds: CGRect(origin: .zero, size: size))
        return render.image{context in
        	self.draw(in: context.format.bounds)
        }
	}
}
```
对于第二个问题，最直接的思想就是采用流式方式处理，降低采样率，避免缓存解码后的数据
```
func resizedCGImage(url: URL, for size: CGSize) -> UIImage? {
/*
kCGImageSourceShouldCache: 避免缓存解码后的数据，因为这个是缩略图，之后的使用场景可能就不一样，所以不要做缓存
kCGImageSourceShouldCacheImmediately: YES表示立马解码，而不是等到渲染的时候才解码
*/  
    let options: [CFString: Any] = [
            kCGImageSourceShouldCache:false,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
        ]
    guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else{                
		return nil
	}
	return image
}
```

##### 3、降低峰值
在图片批量处理的过程中，使用AutoreleasePool来及时释放引用计数为0的对象
```
for image in images {
    @autorelease{
        operation()
    }
}
```
##### 4、裁剪显示的图片
某些场景下，图片不会完整显示出来，比如UIImageView的frame比较小，图片比较大的时候，最后渲染也只会截取显示区域的Image Buffer去进行渲染。这就意味着frame之外的数据是没有必要的。这种场景下，其实只需要裁减显示区域的图片即可。
举个例子，一张1920 * 1080的图片，占用内存为829440 bytes，如果它以ScaleAspectFill的方式放置在一个300 * 300的UIImageView中的话，那么只需要 这种图的43%，也就是360000 bytes就可以了。
```
    func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
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

##### 5、 平时UI代码注意的细节点
* 重写drawRect:UIView是通过CALayer创建FrameBuffer最后显示的。重写了drawRect，CALayer会创建一个backing store，然后在backing store中执行draw函数。而backing store默认大小与UIView大小成正比的。存在的问题：backing store的创建造成不必要的内存开销；UIImage的话先绘制到Backing store，再渲染到frameBuffer，中间多了一层内存拷贝；
* 更多使用Image Assets：更快地查找图片、运行时对内存管理也有优化；
* 使用离屏渲染的场景推荐使用UIGraphicsImageRender替代UIGraphicsBeginIMageContext，性能更高，并且支持广色域。
* 对于图片的实时处理，比如灰色值，这种最好推荐使用CoreImage框架，而不是使用CoreGraphics修改灰度值。因为CoreGraphics是由CPU进行处理，所以使用CoreImage交由GPU去做；

##### 6、 超大图片处理
如果是非常大的图，比如1902 * 1080，那解码之后的大小就达到了近7.9mb。像上述的图片加载方案或者SDWebImage的加载方式，默认就会自动解码缓存，那么如果有连续多张的情况，那内存将瞬间暴涨，甚至闪退。
那解决方案就分为两个场景：
* 如果显示的UIView较小，则应该通过上述降低采样率的方式，加载缩略图；
* 如果是那种像微信、微博详情那样的大图，则应该全屏加载大图，通过拖动来查看不同位置图片的细节。技术细节就是使用苹果的CATiledLayer去加载，它可以分片渲染，滑动时通过映射原图指定位置的部分图片数据解码渲染。

##### 压缩、降低采样率与SDWebImage一起使用
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
* UIImageView加载有哪些方法，分别什么特点，imageWithName加载图片的时候，解码发送在什么时候
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

