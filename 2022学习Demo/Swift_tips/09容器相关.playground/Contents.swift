import UIKit

var greeting = "容器相关"
 
let array: [Any] = [1, "two", 3]
debugPrint(array)


let protocolArray: [CustomStringConvertible] = [1, "two", 3]
debugPrint(protocolArray)

enum ContainerEnum {
    case IntValue(Int)
    case StringValue(String)
}

let eumArray: [ContainerEnum] = [ContainerEnum.IntValue(1),
                                 ContainerEnum.StringValue("two"),
                                 ContainerEnum.IntValue(3)]
debugPrint(eumArray)
