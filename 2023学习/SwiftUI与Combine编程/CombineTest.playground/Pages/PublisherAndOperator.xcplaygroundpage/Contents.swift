import UIKit
import Combine
import CombineTest_Sources

var greeting = "Hello, playground"

let publisher = PassthroughSubject<Int, Never>()
publisher.send(1)
publisher.send(2)
publisher.send(completion: .finished)
print("开始订阅1")
publisher.sink { complete in
    print(complete)
} receiveValue: { value in
    print("sink:\(value)")
}
publisher.send(3)
publisher.send(completion: .finished)

/*
 答案：
 开始订阅1
 finished
 */

let publisher2 = CurrentValueSubject<Int, Never>(0)

print("开始订阅2")
publisher2.value = 1
publisher2.value = 2
publisher2.send(completion: .finished)
publisher2.sink { complete in
    print(complete)
} receiveValue: { value in
    print("sink2:\(value)")
}

/*
 答案：
 开始订阅2
 finished
 */

let publisher2_1 = CurrentValueSubject<Int, Never>(0)
print("开始订阅2_1")
publisher2_1.value = 1
publisher2_1.value = 2
publisher2_1.sink { complete in
    print(complete)
} receiveValue: { value in
    print("sink2_1:\(value)")
}
publisher2_1.send(3)
publisher2_1.send(completion: .finished)
/*
 答案
 开始订阅2_1
 sink2_1:2 // sink之前，1会把0覆盖，2会把1覆盖。
 sink2_1:3
 finished
 */

let publisher3 = CurrentValueSubject<Int, Never>(0)
print("开始订阅3")
publisher3.sink { complete in
    print(complete)
} receiveValue: { value in
    print("sink3:\(value)")
}
publisher3.value = 1
publisher3.value = 2
publisher3.send(3)
publisher3.send(completion: .finished)

/*
 答案：
 开始订阅3
 sink3:0
 sink3:1
 sink3:2
 sink3:3
 finished
 */

print("-------------Publisher 即Operator Demo----------------")
check("Empty") {
Empty<Int, SampleError>() // Empty是一个最简单的Publisher，它只在被订阅的时候发布一个完成事件(receive finished), 不会输出任何output。只能用于表示某个事件已经发生
}

Empty<Int, Error>()
    .print()
    .sink { _ in } receiveValue: { _ in }

check("Just") {
Just(1) // 相比Empty多了一个receive value的Output事件。
}

Just(1)
    .print()
    .sink{_ in } receiveValue: { _ in }
/*
 receive subscription: (Just)
 request unlimited
 receive value: (1)
 receive finished
 */

Publishers.Sequence<[Int], Never>(sequence: [1,2,3])
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
/*
 receive subscription: ([1, 2, 3])
 request unlimited
 receive value: (1)
 receive value: (2)
 receive value: (3)
 receive finished
 */
[1,2,3].publisher
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
/*
 receive subscription: ([1, 2, 3])
 request unlimited
 receive value: (1)
 receive value: (2)
 receive value: (3)
 receive finished
 */

[1, 2, 4].publisher
    .map{ $0 * 2} // 这里是对publisher进行map，相当于是一个Operator，也就是说无论这里是否是数组，都可以使用map来对数据进行变形
    .print()
    .sink { _ in } receiveValue: { _ in }
/*
 receive subscription: ([2, 4, 8])
 request unlimited
 receive value: (2)
 receive value: (4)
 receive value: (8)
 receive finished
 */


[1, 2, 5].map{ $0 * 3} // 这是是对数组进行map，如果不是数组，则无法map
    .publisher
    .print()
    .sink { _ in } receiveValue: { _ in }
/*
 receive subscription: ([3, 6, 15])
 request unlimited
 receive value: (3)
 receive value: (6)
 receive value: (15)
 receive finished
 */

Just(1)
    .map{ $0 * 8 }
    .print()
    .sink { _ in } receiveValue: { _ in }
/*
 receive subscription: (Just)
 request unlimited
 receive value: (8)
 receive finished
 */

[1,2,3,4].publisher
    .reduce(0, +)
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
/*
 receive subscription: (Once)
 request unlimited
 receive value: (10)
 receive finished
 */

[1,2,3,4,5].publisher
    .scan(0, +) // 每个元素都是前面元素之和
    .print()
    .sink { _ in } receiveValue: { _ in }
/*
 receive subscription: ([1, 3, 6, 10, 15])
 request unlimited
 receive value: (1)
 receive value: (3)
 receive value: (6)
 receive value: (10)
 receive value: (15)
 receive finished
 */


["1", "2", "3", "cat", "5"].publisher
    .compactMap { Int($0) } // 和map一样先进行转换操作，然后结果会将nil元素去除掉
    .print()
    .sink { _ in } receiveValue: { _ in }
/*
 receive subscription: ([1, 2, 3, 5])
 request unlimited
 receive value: (1)
 receive value: (2)
 receive value: (3)
 receive value: (5)
 receive finished
 */

["1", "2", "3", "cat", "5"].publisher
    .map { Int($0) }
    .filter { $0 != nil }
    .map { $0! }
    .print()
    .sink { _ in } receiveValue: { _ in }
/*
 receive subscription: ([1, 2, 3, 5])
 request unlimited
 receive value: (1)
 receive value: (2)
 receive value: (3)
 receive value: (5)
 receive finished
 */

[[1,2,3],[[4, 5]], [[6], [7, 8]]].publisher
    .flatMap {
        $0.publisher
    }
    .print()
    .sink { _ in } receiveValue: { _ in }
/*
 receive subscription: (FlatMap)
 request unlimited
 receive value: (1)
 receive value: (2)
 receive value: (3)
 receive value: ([4, 5])
 receive value: ([6])
 receive value: ([7, 8])
 receive finished
 */

["A", "B", "C"].publisher
    .flatMap { letter in
        [1, 2, 3]
            .publisher
            .map { "\(letter)\($0)"}
    }
    .print()
    .sink { _ in } receiveValue: { _ in }
/*
 receive subscription: (FlatMap)
 request unlimited
 receive value: (A1)
 receive value: (A2)
 receive value: (A3)
 receive value: (B1)
 receive value: (B2)
 receive value: (B3)
 receive value: (C1)
 receive value: (C2)
 receive value: (C3)
 receive finished
 */

["S", "Sw", "Sw", "Sw", "Swi",
 "Swif", "Swift", "Swift", "Swif"].publisher
    .removeDuplicates()
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
/*
 receive subscription: (["S", "Sw", "Swi", "Swif", "Swift", "Swif"])
 request unlimited
 receive value: (S)
 receive value: (Sw)
 receive value: (Swi)
 receive value: (Swif)
 receive value: (Swift)
 receive value: (Swif)
 receive finished
 */

public enum MyError: Error {
    case myerror
}

Fail<Int, SampleError>(error: .sampleError)
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
/*
 receive subscription: (Empty)
 request unlimited
 receive error: (sampleError)
 */

Fail<Int, SampleError>(error: .sampleError)
    .mapError({ _ in
        MyError.myerror
    })
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
/*
 receive subscription: (Empty)
 request unlimited
 receive error: (myerror)
 */

["1", "2", "Swift", "4"].publisher
    .tryMap { s -> Int in
        guard let value = Int(s) else {
            throw MyError.myerror
        }
        return value
    }
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
/*
 receive subscription: (TryMap)
 request unlimited
 receive value: (1)
 receive value: (2)
 receive error: (myerror)
 */

["1", "2", "Swift", "4"].publisher
    .tryMap { s -> Int in
        guard let value = Int(s) else {
            throw MyError.myerror
        }
        return value
    }
    .replaceError(with: -1) // 会在发生error的地方替换成-1返回
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
/*
 receive subscription: (ReplaceError)
 request unlimited
 receive value: (1)
 receive value: (2)
 receive value: (-1)
 receive finished
 */

["1", "2", "Swift", "4"].publisher
    .tryMap { s -> Int in
        guard let value = Int(s) else {
            throw MyError.myerror
        }
        return value
    }
    .catch { _ in Just(-1) } // 这里替换成了一个Just Publisher
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
/*
 receive subscription: (Catch)
 request unlimited
 receive value: (1)
 receive value: (2)
 receive value: (-1)
 receive finished
 */

["1", "2", "Swift", "4"].publisher
    .tryMap { s -> Int in
        guard let value = Int(s) else {
            throw MyError.myerror
        }
        return value
    }
    .catch { _ in [-1,-2,-3].publisher } // 这里替换成了一个Publishers.Sequence
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
/*
 receive subscription: (Catch)
 request unlimited
 receive value: (1)
 receive value: (2)
 receive value: (-1)
 receive value: (-2)
 receive value: (-3)
 receive finished
 */

["1", "2", "Swift", "4"].publisher
    .flatMap { s in
        return Just(s)
            .tryMap { s -> Int in
                guard let value = Int(s) else {
                    throw MyError.myerror
                }
                return value
            }
            .catch { _ in Just(-1) }
    }
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
/*
 receive subscription: (FlatMap)
 request unlimited
 receive value: (1)
 receive value: (2)
 receive value: (-1)
 receive value: (4)
 receive finished
 */

["1", "2", "Swift", "4"].publisher
    .print("[ Original ]")
    .flatMap { s in
        return Just(s)
            .tryMap { s -> Int in
                guard let value = Int(s) else {
                    throw MyError.myerror
                }
                return value
            }
            .print("[ TryMap ]")
            .catch { _ in Just(-1).print("[ Just ]") }
            .print("[ Catch ]")
    }
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }
/*
 中间的Print是调试步骤。需要慢慢研究
 receive subscription: (FlatMap)
 request unlimited
 [ Original ]: receive subscription: (["1", "2", "Swift", "4"])
 [ Original ]: request unlimited
 [ Original ]: receive value: (1)
 [ TryMap ]: receive subscription: (Once)
 [ Catch ]: receive subscription: (Catch)
 [ Catch ]: request unlimited
 [ TryMap ]: request unlimited
 [ TryMap ]: receive value: (1)
 [ Catch ]: receive value: (1)
 receive value: (1)
 [ TryMap ]: receive finished
 [ Catch ]: receive finished
 [ Original ]: receive value: (2)
 [ TryMap ]: receive subscription: (Once)
 [ Catch ]: receive subscription: (Catch)
 [ Catch ]: request unlimited
 [ TryMap ]: request unlimited
 [ TryMap ]: receive value: (2)
 [ Catch ]: receive value: (2)
 receive value: (2)
 [ TryMap ]: receive finished
 [ Catch ]: receive finished
 [ Original ]: receive value: (Swift)
 [ TryMap ]: receive subscription: (Empty)
 [ Catch ]: receive subscription: (Catch)
 [ Catch ]: request unlimited
 [ TryMap ]: request unlimited
 [ TryMap ]: receive error: (myerror)
 [ Just ]: receive subscription: (Just)
 [ Just ]: request unlimited
 [ Just ]: receive value: (-1)
 [ Catch ]: receive value: (-1)
 receive value: (-1)
 [ Just ]: receive finished
 [ Catch ]: receive finished
 [ Original ]: receive value: (4)
 [ TryMap ]: receive subscription: (Once)
 [ Catch ]: receive subscription: (Catch)
 [ Catch ]: request unlimited
 [ TryMap ]: request unlimited
 [ TryMap ]: receive value: (4)
 [ Catch ]: receive value: (4)
 receive value: (4)
 [ TryMap ]: receive finished
 [ Catch ]: receive finished
 [ Original ]: receive finished
 receive finished
 */

//[1: "A", 2: "B", 3: "C"].timerPublisher
//    .print()
//    .sink { _ in
//    } receiveValue: { _ in
//    }

