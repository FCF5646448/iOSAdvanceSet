import UIKit

var greeting = "初始化"

class Cat {
    var name: String // 未初始化
    init() {
        name = "cat"
    }
}

class Tiger: Cat {
    let power: Int // 未初始化
    var height: Int = 1 // 已初始化
    override init() {
        power = 10 // 先初始化未初始化的参数
        super.init() // 调用父类
        name = "tiger" // 更改已初始化的值
        height = 100 // 更改已初始化的值
    }
}

class Tiger2: Cat {
    let power: Int // 未初始化
    var height: Int = 1 // 已初始化
    // 无需显示调用super.init()
    override init() {
        power = 10 // 先初始化未初始化的参数
        height = 100 // 更改已初始化的值
    }
}

debugPrint(Tiger().name)
debugPrint(Tiger2().height)
