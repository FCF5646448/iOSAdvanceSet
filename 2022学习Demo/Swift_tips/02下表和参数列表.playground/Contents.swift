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
