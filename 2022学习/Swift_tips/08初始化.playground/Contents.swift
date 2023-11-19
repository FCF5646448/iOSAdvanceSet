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
    
    convenience init?(param2: Int) {
        if param2 > 0 {
            self.init(param: param2)
        } else {
            return nil
        }
    }
    
    required convenience init(param: Int, frame: CGRect) {
        self.init(param: param)
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
    init() {
        super.init(param: 0) // 如果把父类的override init(frame: CGRect)方法注释掉的话，这里不能直接跨越层级执行super.init(frame: frame)，而是必须执行父类中已有的几个初始化方法，这样父类中的指定初始化器路径才能走全。
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience init(param: Int, frame: CGRect) {
        fatalError("init(param:frame:) has not been implemented")
    }
}
