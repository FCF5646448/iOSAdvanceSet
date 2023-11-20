//: [Previous](@previous)

import Foundation
import UIKit
import Combine

var greeting = "Subject"

let subject = PassthroughSubject<Int, Never>()
// 这里需要用一个变量持有，否则，后续的print不会打印
let s = subject
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }

delay(1) {
    subject.send(1)
    delay(1) {
        subject.send(2)
        delay(1) {
            subject.send(completion: .finished)
        }
    }
}
/*
 如果不用let s 持有的话，会无法输出。暂时不知道原因
 receive subscription: (PassthroughSubject)
 request unlimited
 receive value: (1)
 receive value: (2)
 receive finished
 */

let subject_example1 = PassthroughSubject<Int, Never>()
let subject_example2 = PassthroughSubject<Int, Never>()

// 这里会产生一个新的Merge Publisher
subject_example1.merge(with: subject_example2)
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }

subject_example1.send(20)
subject_example2.send(1)
subject_example1.send(40)
subject_example1.send(60)
subject_example2.send(1)
subject_example1.send(80)
subject_example1.send(100)
subject_example1.send(completion: .finished)
subject_example2.send(completion: .finished)

/*
 merge后的Publisher，是按1、2的send时序发的
 receive subscription: (Merge)
 request unlimited
 receive value: (20)
 receive value: (1)
 receive value: (40)
 receive value: (60)
 receive value: (1)
 receive value: (80)
 receive value: (100)
 receive finished
 receive cancel
 */


let sub1 = PassthroughSubject<Int, Never>()
let sub2 = PassthroughSubject<String, Never>()

sub1.zip(sub2)
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
sub1.send(1)
sub2.send("A")
sub1.send(2)
sub2.send("B")
sub2.send("C")
sub2.send("D")
sub1.send(3)
sub1.send(4)
sub1.send(5) // 被忽略了

/*
 receive subscription: (Zip)
 request unlimited
 receive value: ((1, "A"))
 receive value: ((2, "B"))
 receive value: ((3, "C"))
 receive value: ((4, "D"))
 receive cancel
 */

let sub3 = PassthroughSubject<Int, Never>()
let sub4 = PassthroughSubject<String, Never>()

sub3.combineLatest(sub4)
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
sub3.send(1)
sub4.send("A")
sub3.send(2)
sub4.send("B")
sub4.send("C")
sub4.send("D")
sub3.send(3)
sub3.send(4)
sub3.send(5)

/*
 receive subscription: (CombineLatest)
 request unlimited
 receive value: ((1, "A"))
 receive value: ((2, "A"))
 receive value: ((2, "B"))
 receive value: ((2, "C"))
 receive value: ((2, "D"))
 receive value: ((3, "D"))
 receive value: ((4, "D"))
 receive value: ((5, "D"))
 receive cancel
 */

func loadPage(url: URL, handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        handler(data, response, error)
    }
    .resume()
}

let future = Future<(Data, URLResponse), Error> { promise in
    loadPage(url: URL(string: "https:www.baidu.com")!) { data, response, error in
        if let data = data, let response = response {
            promise(.success((data, response)))
        } else {
            promise(.failure(error!))
        }
    }
}
.print()
.sink { _ in
} receiveValue: { _ in
}

/*
 receive value: ((2443 bytes, <NSHTTPURLResponse: 0x600000203d60> { URL: https://www.baidu.com/ } { Status Code: 200, Headers {
     "Content-Encoding" =     (
         gzip
     );
     "Content-Length" =     (
         1145
     );
     "Content-Type" =     (
         "text/html"
     );
     Date =     (
         "Mon, 20 Nov 2023 10:07:42 GMT"
     );
     Server =     (
         bfe
     );
 } }))
 receive finished
 */

//var observer: NSObjectProtocol?
//let sub5 = PassthroughSubject<(), Never>()
//observer = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main, using: { _ in
//    sub5.send()
//})

let sub6 = PassthroughSubject<Date, Never>()
Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
    sub6.send(Date())
}

let timer = sub6.print()
    .sink { _ in
    } receiveValue: { _ in
    }
delay(6) {
    // 取消定时器
    sub6.send(completion: .finished)
}
/*
每隔1秒，发送一次
 receive value: (2023-11-20 10:21:58 +0000)
 receive value: (2023-11-20 10:21:59 +0000)
 receive value: (2023-11-20 10:22:00 +0000)
 receive value: (2023-11-20 10:22:01 +0000)
 receive value: (2023-11-20 10:22:02 +0000)
 receive value: (2023-11-20 10:22:03 +0000)
 receive finished
 */



