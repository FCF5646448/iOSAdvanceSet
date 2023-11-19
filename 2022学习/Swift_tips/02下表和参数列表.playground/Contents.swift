import UIKit

var greeting = "下标和参数列表"

// 扩展一个一次性读取或写入多个元素的数组
extension Array {
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count, "index out of range")
                result.append(self[i])
            }
            return result
        }
        
        set {
            for (index, i) in input.enumerated() {
                assert(i < self.count, "index out of range")
                self[i] = newValue[index]
            }
        }
    }
}

var arr = [1,2,3,4,5]
debugPrint(arr[[0,2,3]])
arr[[0,2,3]] = [-1,-3,-4]
debugPrint(arr)

// --------------可变参数---------------

struct Sum {
    func sum(input: Int...) -> Int {
        return input.reduce(0, +)
    }
    
    func sum2(nums: Int..., initValue: Int) -> Int {
        return nums.reduce(0, +) + initValue
    }
}

let sum = Sum()
debugPrint(sum.sum(input: 1,2,3,4,5))
debugPrint(sum.sum2(nums: 1,2,3,4,5, initValue: 10))


