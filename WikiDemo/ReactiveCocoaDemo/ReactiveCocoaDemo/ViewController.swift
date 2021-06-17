//
//  ViewController.swift
//  ReactiveCocoaDemo
//
//  Created by 冯才凡 on 2021/6/14.
//  Copyright © 2021 冯才凡. All rights reserved.
//

import UIKit
//import ReactiveCocoa
import ReactiveSwift

class MyError: Error {
    var message: String
    init(message: String) {
        self.message = message
    }
    func display() -> String {
        return message + "MyError message"
    }
}

enum CusError: Error {
    case cusError
    var desc: String {
        return "custom error"
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        useDemo()
    }
}


extension ViewController {
    /// racswift使用
    func useDemo() {
        
        /// 1、 Never表示永远不会发生的事情，这里也就表示这个signal不会产生错误，效果就是signal监听，observer发送。
        /// 函数：pipe(disposable: Disposable? = nil) -> (output: Signal, input: Observer) 返回一个元组。从命名可以看出，Signal表示管道的输出，Observer表示管道的输入。
        let (signal, observer) = Signal<Int, Never>.pipe()
        signal.observeValues { value in
            print(value)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            observer.send(value: 1)
            /// 表示发送结束，所以后面的send 2 不会产生效果
            observer.sendCompleted()

            observer.send(value: 2)
        }

        

        print("--------------------------------------------")
        /// 2、error和complete一样，执行了就不会再监听value的变化了
        let (signal2, observer2) = Signal<Int, CusError>.pipe()
        signal2.observeResult { result in
            switch result {
            case let .success(value):
                print(value)
            case let .failure(error):
                print(error.desc)
            }
        }
        signal2.observeFailed { error in
            print(error.desc)
        }

        /// value和error只会执行一个
        observer2.send(value: 2)
        observer2.send(value: 3)
        observer2.send(error: CusError.cusError)
        
        
        let (signal3, observer3) = Signal<Int, Never>.pipe()
        signal3.map{ $0 + 2}.observeValues { value in
            print(value)
        }
        observer3.send(value: 3)
        
        
        
    }
}


extension ViewController {
    /// racswift源码学习
    func racSwiftLearn() {
        
        /// 创建一个signal和observer，观察signal的生命周期。obser是输入，signal是输出。signal可以订阅一序列的观察（底层是数组），obser用于发出消息。
        var obser: Signal<String, CusError>.Observer?
        let signal = Signal<String, CusError>.init { observer, lifetime in
            obser = observer
            lifetime.observeEnded {
                print("signal life end")
            }
        }
        
        /// 监听对象
        let observer = Signal<String, CusError>.Observer.init { event in
            print("observer event:\(event)")
        }
        signal.observe(observer)
        
        /// 观察事件
        signal.observe { event in
            print("observer方法： \(event)")
        }
        
        ///观察结果
        signal.observeResult { result in
            switch result {
            case let .success(value):
                print(value)
            case let .failure(error):
                print(error.desc)
            }
        }
        
        /// 观察失败事件
        signal.observeFailed { error in
            print(error.desc)
        }
        
        /// 观察完成
        signal.observeCompleted {
            print("complete")
        }
        
        /// 发送value消息
        obser?.send(value: "123")
        /*
         得到的结果：
         observer event:VALUE 123
         observer方法： VALUE 123
         123
         observer event:INTERRUPTED
         observer方法： INTERRUPTED
         signal life end

         */
        
        /// error之后不会再响应send
        obser?.send(error: .cusError)
        obser?.send(value: "456")
        /*
         得到结果：
         observer event:FAILED cusError
         observer方法： FAILED cusError
         custom error
         custom error
         signal life end
         */
        
        
        /// complete之后不会再响应send
        obser?.send(value: "789")
        obser?.sendCompleted()
        obser?.send(value: "101")
        /*
         得到结果：
         observer event:VALUE 789
         observer方法： VALUE 789
         789
         observer event:COMPLETED
         observer方法： COMPLETED
         complete
         signal life end
         */
        
        
    }
    
}
