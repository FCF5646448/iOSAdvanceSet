#### 创建私有库

1、先去gitlab上创建一个仓库：BTNetWork

2、使用命令把仓库拉取到本地：

```
pod repo add BTNetWork https://gitlab.btclass.cn/caifan/btnetwork.git
```

然后我们就可以在本地 ~/.cocoapods/repos中看到新建的BTNetWork仓库了。

#### 创建测试项目

1、创建一个远程项目，clone到本地。这个项目用于作为BTNetWork的Demo来用。

2、进入到Demo文件夹，使用命令创建pod 项目

```
pod lib create BTNetWorkDemo
```

会出现一系统提问：

```
What platform do you want to use?? [ iOS / macOS ] //平台
 > iOS

What language do you want to use?? [ Swift / ObjC ] //语言
 > Swift

Would you like to include a demo application with your library? [ Yes / No ] //是否生成模板库
 > Yes

Which testing frameworks will you use? [ Quick / None ] //是否集成测试框架
 > None

Would you like to do view based testing? [ Yes / No ] //是否做基于view的测试
 > No
```

最后项目创建成功后，会自动启动。

3、创建好的项目有一个BTNetWorkDemo文件夹和一个Example文件夹。BTNetWorkDemo文件夹就主要是用来放置最终pod库里的代码的。

所以，我们将需要生成库的代码导入进BTNetWorkDemo文件夹下的class文件夹中，资源放到BTNetWorkDemo文件夹下Assets中。

文件导入进来后，我们使用命令，将导入的文件pod进项目中。

```
pod install
```

4、修改xx.podspec

podspec就是一个索引文件。最终这个索引文件会被提交到第一章生成的私有库中。

主要的内容包括：

```
Pod::Spec.new do |s|
  s.name             = 'BTNetWorkDemo'
  s.version          = '0.0.1'
  s.summary          = 'BT学院通用APP层基础组件——NetWork'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'BT学院NetWork组件，主要用于网络请求与解析的分装'
                       DESC

  s.homepage         = 'https://gitlab.btclass.cn/caifan/btnetworkdemo.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'FCF' => '2998000457@qq.com' }
  s.source           = { :git => 'https://gitlab.btclass.cn/caifan/btnetworkdemo.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.3'

  s.source_files = 'BTNetWorkDemo/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BTNetWorkDemo' => ['BTNetWorkDemo/Assets/*.png']
  # }

  # 依赖库
  s.public_header_files = 'Pod/Classes/**'
  s.dependency 'Alamofire', '~> 4.8.2'
  s.dependency 'HandyJSON', '5.0.2-beta'
  s.dependency 'Moya','~> 13.0.1'
  
end
```

5、如果有需要的第三方依赖库，也写到Podfile里，执行

```
pod install
```

这样差不多就可以使用这个pod了，可以在Example里写对应的测试代码了。



[创建cocoapod私有库详细步骤](<https://www.jianshu.com/p/f903ecf8e882>)

[在现有工程中实施CTmediator](<https://casatwy.com/modulization_in_action.html>)





### 创建主项目





#### 存在的问题

1、pod里不知道怎么使用OC和swift混编，貌似一个pod只能是一种语言；

2、pch没法共用；



