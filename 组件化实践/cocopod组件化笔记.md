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

这样差不多就可以使用这个Demo了，可以在Example里写对应的测试代码了。

6、写代码的过程

* 如果你要重新创建文件夹或文件，新建的文件夹会在项目的根目录，需要自己手动移到class文件夹下。然后pod install，就可以将代码导进Demo中。
* 

7、完成之后回到项目文件夹将代码提交到仓库。然后给podspec打上tag

```
$git tag 0.0.1 #注意这里的tag和podspec的version一样
$git push --tag
```

8、验证podspec。这一步是最难的，因为不允许出现错误，只要报错就无法push到repos。

```
pod spec lint --verbose --allow-warnings --use-libraries #--allow-warnings表示忽略警告，--use-libraries表示有使用第三方库
```

* 第一个错误：
```
ERROR | [iOS] unknown: Encountered an unknown error (Could not find a `ios` simulator (valid values: ). Ensure that Xcode -> Window -> Devices has at least one `ios` simulator listed or otherwise add one.
```
查看博客[pod lib lint报错001](<https://www.jianshu.com/p/5a160a64c0fd>) , 大概是说要升级cocoapod。
然后执行
```
sudo gem install cocoapods
```
又报错：Error installing cocoapods:  \n ERROR: Failed to build gem native extension.
查找问题[Errors when installing cocoapods with gem](https://stackoverflow.com/questions/60481623/errors-when-installing-cocoapods-with-gem)是说需要切换到xcode的ruby：

```
$sudo xcode-select --switch /Library/Developer/CommandLineTools
$ruby -rrbconfig -e 'puts RbConfig::CONFIG["rubyhdrdir"]'
```
然后重新sudo gem install cocoapods。成功

**注意**：成功之后要把ruby 切换回去，否则 pod spec lint 仍然不成功
```
sudo xcode-select --switch /Applications/Xcode.app
```

重新执行，pod spec lint … 成功了会有 xx.podspec passed validation.

9、将验证完的podspec库push到第一步创建的私有库里，执行

```
$pod repo push BTCoreKit BTCoreKitDemo.podspec --allow-warnings #前面是索引库名，后面是podspec文件名
```

这里也有个点需要注意，就是索引库必须先关联远程仓库，如果只clone下来，push也是会报错的。

end

这样一个私有仓库就算是创建完成了。

[创建cocoapod私有库详细步骤](<https://www.jianshu.com/p/f903ecf8e882>)

[在现有工程中实施CTmediator](<https://casatwy.com/modulization_in_action.html>)

### 创建主项目

主项目可以使用development pods + pods的组合来创建。development pods存放本地私有仓库，pods存放远程共有仓库。

1、使用xcode创建主项目。

2、创建podfile文件，注意，文件里的内容，本地私有仓库使用path，path的值等于私有仓库xx.podspec的文件地址。这样最后创建出来的项目就自动带有development pods文件夹。

```
platform :ios, '9.0'

target 'ModularTestDemo2' do
use_frameworks!
#远程仓库
pod 'Alamofire', '~> 4.8.2'
#本地组件
pod 'BTCoreKitDemo', :path => "../../btcorekitdemo/BTCoreKitDemo"
end
```

3、对development pod库的修改，修改后回到对应的库的Example里执行pod update。更新到对应pod的代码库中。



#### 存在的问题

1、pod里不知道怎么使用OC和swift混编，貌似一个pod只能是一种语言；
2、pch没法共用；

#### 实战：

实战开发中，并不需要每一个pod包都创建一个仓库。只需要用一个仓库，然后用development pod隔开。这样每次私有库创建过程中就无需第八步验证阶段了。



#### 处理的问题：
* source文件的打包问题：
正常来说，对应pod的资源放入到对应的Asset文件里面，pod库打出来时，会自动包含里面的资源。其次对于没有放到Assets文件里的资源，可以在podspesc中设置：
```
   s.resource_bundles = {
     'BTCoreKitDemo' => ['BTCoreKitDemo/Assets/*.png']
     'SVProgressHUD' => ['BTCoreKit/BTCoreKit/Classes/ThirdParty/HUB/SVProgressHUD/*.png']
   }
```
这样打出来的pod就对应两个bundle，但是在使用过程中，类似SVProgressHUD.bundle不一定能够找得到，所以其实可以直接使用资源名称。因为podxx.framework中会包含对应的资源文件，可以直接被访问到。
* 各个pod的桥接文件使用：
  * 如果pod库B是一个swift和OC混编的，那么在B库中是没法生成B-bridge-header.h文件夹的。所以，如果要在OC中使用swift代码，可以直接使用#import <B/B-Swift.h>,这样就能在里面找到对应的编译成OC的swift类。如果要在swift中使用 OC代码，则可以直接创建一个xx.h的头文件，然后将OC文件的头文件索引放进去，这样在swift项目中就能够直接使用OC文件。

  * 如果两个另一个pod库A的swift文件中需要使用该混编的库B中的OC文件，则使用同样的套路：在A中创建一个xxx.h的OC头文件，然后将B库中的OC文件导入进去，但是要注意是名称，比如：#import "B/HUBManager.h"；如果A中的OC文件要是有B中的Swift文件，则同样导入#import <B/B-Swift.h>，就能访问编译成OC的swift类。

同样这里要注意的是外部的类要是有pod库里的swift，则swift类必须得是public访问权限，如果OC要访问swift类，则swift类必须是@objc public访问权限。






[创建cocoapod私有库详细步骤](<https://www.jianshu.com/p/f903ecf8e882>)

[模块化之路实践](<https://www.jianshu.com/p/9d49216682f4>)

[CTMediator的swift应用](<https://casatwy.com/CTMediator_in_Swift.html>)









