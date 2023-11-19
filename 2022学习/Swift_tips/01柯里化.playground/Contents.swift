import UIKit
import Foundation

var greeting = "柯里化"


func addTo(_ adder: Int) -> (Int) -> Int {
    return { num in
        return num + adder
    }
}

let addOne = addTo(2)
print(addOne)
let result = addOne(6)
print(result)


func greaterThan(_ comparer: Int) -> (Int) -> Bool {
    return { num in
        return num > comparer
    }
}

let greaterThan10 = greaterThan(10)
print(greaterThan10)
print(greaterThan10(13))
print(greaterThan10(8))


protocol TargetAction {
    func performAction()
}

/// target —— action 模板方法
struct TargetActionWrapper<T: AnyObject>: TargetAction {
    weak var target: T?
    let action: (T) -> () -> ()
    func performAction() {
        if let target = target {
            action(target)()
        }
    }
}

/// 事件类型
enum ControlEvent {
    case touchInside
    case valueChanged
}

class Control {
    var actions = [ControlEvent: TargetAction]()
    func setTarget<T: AnyObject>(target: T,
                                 action: @escaping (T) -> () -> (),
                                 controlEvent: ControlEvent) {
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
    }
    
    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }
    
    func performActionForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performAction()
    }
}
