import UIKit

var greeting = "Hello, 闭包"

class BlockTest {
    let testBlock: ((Int) -> Void)
    var testBlock1: ((Int) -> Void)?
    
    init(block: @escaping ((Int) -> Void)) {
        self.testBlock = block
        debugPrint("init call end")
    }
     
    func testFunc(block: @escaping ((Int) -> Void)) {
        self.testBlock1 = block
        debugPrint("testFunc call end")
    }
    
    func test() {
        debugPrint("test call begin")
        self.testBlock(10)
        self.testBlock1?(20)
        debugPrint("test call end")
    }
}

//let text = BlockTest { num in
//    debugPrint("init num:\(num)")
//}
//text.testFunc { num in
//    debugPrint("testFunc num:\(num)")
//}
//text.test()


class BlockTest2 {
    func blockTest1(num: Int, _ synBlock: ((_ num: Int) -> Bool)) {
        if synBlock(num) {
            debugPrint("blockTest1 synBlock")
        }
        debugPrint("blockTest1 call")
    }
    
    func blockTest2(num: Int, _ asynBlock: @escaping ((_ num: Int) -> Bool)) {
        DispatchQueue.main.async {
            if asynBlock(num) {
                debugPrint("blockTest2 asynBlock")
            }
        }
        debugPrint("blockTest2 call")
    }
    
    func blockTest3(num: Int, _ asynBlock: @escaping ((_ num: Int) -> Bool)) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
            if asynBlock(num) {
                debugPrint("blockTest3 asynBlock")
            }
        })
        debugPrint("blockTest3 call")
    }
    
    func blockTest4(num: Int, _ asynBlock: ((_ num: Int) -> Bool)?) {
        DispatchQueue.main.async {
            guard let asynBlock = asynBlock else {
                debugPrint("blockTest4 asynBlock is nil")
                return
            }
            if asynBlock(num) {
                debugPrint("blockTest4 asynBlock")
            }
        }
        debugPrint("blockTest4 call")
    }
}


let test2 = BlockTest2()
test2.blockTest1(num: 1) { num in
    return num % 2 == 1
}

test2.blockTest2(num: 1) { num in
    return num % 2 == 1
}

test2.blockTest3(num: 1) { num in
    return num % 2 == 1
}

test2.blockTest4(num: 1) { num in
    return num % 2 == 1
}
