//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Hello, playground"

let timer = Timer.publish(every: 1, on: .main, in: .default)
let temp = check("Timer Connected") {
    timer
}
let result = timer.connect() // 这个Timer.Publisher是一个ConnectablePublisher，它需要明确地调用connect(), 它才会开始发送事件

delay(10) {
    result.cancel() // 取消定时器
}

/*
 这里会开始每一秒打印时间
 */


//NotificationCenter.default.publisher(for: xxx, object: nil)
//    .print()
//    .sink { _ in
//    } receiveValue: { _ in
//    }

