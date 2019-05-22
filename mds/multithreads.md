---
title: multithreads
date: 2019-02-19 11:56:52
tags: 多线程
categories: iOS进阶
description: 多线程
---

GCD** : 多核并行运算的解决方案，可以合理利用更多CPU内核。更主要的是自动管理线程的生命周期，只需要告诉GCD干什么就行。

1、任务方面：同步Sync（执行完当前任务才会执行下一个任务）、异步Async（不需要等待当前任务执行完毕）；
队列相关：串行Serial（任务一个一个发出）、并行Concurrent（多个任务同时执行）；

2、global_queue是一个并发队列，创建全局队列时，第一个参数是一个优先级的标识，所以如果要在并行队列中，让任务先执行，这可以通过设置这个优先级来达到目的（但是这里要注意，先执行并不一定是第一个执行完，它只能保证开始的执行顺序而已）。它的优先级包括（低-高：background（同步备份数据）、utility（需要时间的下载）、default、user-Initiated(用户出发的，如打开文件)、user-Interractive(用户交互，如主线程事件)）

3、Dispatch_Barrier栅栏，实现多读单写

```swift
A{
    set{
        ConcurentQueue.async(flogs:.barrier){
            _a = newvalue
        }
    }
    get{
        ConcurentQueue.sync{
            return _a
        }
    }
    
}
```

4、信号量：信号量可以改变全局队列里设置好的优先级。

```swift
var highQueue = Dispatch.global(qos:.userInitiated)
var lowQueue = Dispatch.global(qos:.utility)

let semaphore = DispatchSemaphore(value:1)
lowQueue.asycn{
    semaphore.wait()
    sleep(1000)
    semaphore,signal()
}
highQueue.asycn{
    semaphore.wait()
    sleep(1000)
    semaphore,signal()
}
//这里lowQueue的优先级更高。
```

5、死锁的几种情况

```swift
//1、串行队列：异步里同步嵌套
SerialQueue.async{
    print(1)
    SerialQueue.sync{
        print(2)
    }
}
//2、串行队列：同步里同步嵌套
SerialQueue.sync{
    print(1)
    SerialQueue.sync{
        print(2)
    }
}
//3、主线程中执行同步操作
viewDidLoad(){
    DispatchQueue.main.sync{
        print(3)
    }
}
//4、NSOperation 线程间依赖
let operaA = Operation()
let operaB = Operation()
operaA.addDependency(operaB)
operaB.addDependency(operaA)
```

6、dispatch_group
dispatch_group_async里应该执行同步请求，如果执行异步请求，线程会立即返回，达不到想要的效果，所以要使用dispatch_group_enter(group)和dispatch_group_leave(group)来实现

```oc
{
    dispatch_group_t group = dispatch_group_create()
    
    dispatch_group_enter(group)
    self.request1({
      sleep(1000)
      dispatch_group_leave(group)
    })
    
    dispatch_group_enter(group)
    self.request2({
      sleep(1000)
      dispatch_group_leave(group)
    })
    
    dispatch_group_notify(group,dispatch_get_main_queue(),^{
        print(finish)
    })
}
```

**Operation**
Operation是指一个单独的任务，然后把它放到OperationQueue中实现多线程运行效果，OperationQueue实现了暂停、继续、终止、优先顺序、依赖等操作。同时通过设置最大并发量maxConcurentOperationCount来确定其实串行还是并发。
Operation包含有常见4个状态：isReady(就绪)、Executing(运行中)、Cancelled(取消)、finished(完成)。
实现NSOperation可以通过它的子类NSIvocationOperation和NSBlockOperation，或者继承自NSOperation自定义。
1、Operation的取消操作，如果任务已经开始，那此时调用cancel是没有用的，所以得等任务结束之后判断是否isCancel来确定是否继续接下来的操作
2、依赖关系，如果存在相互依赖的环就会造成死锁
3、单纯的NSIvocationOperation和NSBlockOperation的start方法是同步执行的，要放到OperationQueue里才能实现异步执行
4、自定义Operation的时候，如果不重新它的状态方法，只重写main函数(执行体在main函数里)，则它的状态可以直接使用不需要代码控制，所以说也可以通过重写isReady、isCancelled、isFinish等方法来控制状态。
5、自定义Operation的时候，main函数里的执行体同样是同步执行的，那如果要异步请求一些操作，则应该和runloop结合起来使用

```swift
class CusOperation:Operation{
    var over:Bool = false
    override main(){
        ConCurentQueue.async{
            sleep(1000)
            self.over = true
        }
        while(!self.over && !self.isCancelled){
            NSRunloop.current.runmode(.default,beforeDate:NSDate.distanceFuture)
        }
    }
}
```

所以总结一下：NSOperation较与GCD，就是可以添加依赖、最大并发量、控制状态。