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


class CustomView: UIView {
    let param: Int
    
    convenience init(param: Int, frame: CGRect) {
        self.init(param: param) // 注意必须是自己的
        // 如果这里调用的是init（frame：）初始化器，则可以在调用init后赋值
    }
    
    init(param: Int) {
        self.param = param
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        self.param = 0
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        self.param = 0
        super.init(coder: coder)
    }
}
 
class SubCustomView: CustomView {
    
}
