import UIKit

protocol State {
    associatedtype StateType
    func add(_ item:StateType)
}

struct SubStates<T>:State {
//    typealias StateType = Int
    func add(_ item: T) {
        print(item)
    }
}

struct Demo {
    typealias StateType = Int
    var delegate:SubStates<Int>?
}

//subStates().add(2)
//Demo().delegate?.add(3)

//一个Int型的迭代器
class stateItr : IteratorProtocol {
//    typealias Element = Int
    var num : Int = 1
    func next() -> Int? {
        num += 2
        return num
    }
}

func finNext<I:IteratorProtocol>(item:I) -> AnyIterator<I.Element> where I.Element == Int {
    var l = item
    print(l.next() as Any)
    return AnyIterator { l.next() }
}

finNext(item: finNext(item: finNext(item: stateItr())))



//map, 对集合里的每一个元素做处理，返回一个新的集合，老的集合不变
var nums = ["A","B","C"]
func add(n:String) -> String {
    return n + "😁"
}

//注意这里直接将add作为参数传进去
let newNums = nums.map(add)
print(nums)
print(newNums)

//flatMap,将二维数组降为一位数组进行处理，然后返回一维数组
var name1 = ["lili","jinjin","mingming"]
var name2 = ["yy","xx","zz"]
var names = [name1, name2]
let newNames = names.flatMap {$0.map(add)}
print(names)
print(newNames)


//reduce 累加器
var ns = [1,2,3]
let r = ns.reduce(6) { (x, y) in
    x + y
}
print(r)


