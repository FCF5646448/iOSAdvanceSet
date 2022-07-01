import UIKit

var greeting = "KVO"

class MyClass: NSObject {
    @objc dynamic var date = Date()
}

private var myContext = 0

class Class: NSObject {
    var myObject: MyClass!
    
    override init() {
        super.init()
        myObject = MyClass()
        print("初始化MyClass，当前日期：\(myObject.date)")
        myObject.addObserver(self, forKeyPath: "date", options: .new, context: &myContext)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            self.myObject.date = Date()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let change = change, context == &myContext {
            if let newDate = change[.newKey] as? Date {
                print("MyClass日期发生变化：\(newDate)")
            }
        }
    }
    
    deinit {
        myObject.removeObserver(self, forKeyPath: "date")
        debugPrint("Class deinit")
    }
}

let obj = Class()

class OtherClass: NSObject {
    var myObject: MyClass!
    var observation: NSKeyValueObservation?
    
    override init() {
        super.init()
        myObject = MyClass()
        print("初始化MyClass2，当前日期：\(myObject.date)")
        
        observation = myObject.observe(\MyClass.date, options: [.new], changeHandler: { _, change in
            if let newDate = change.newValue {
                print("MyClass2日期发生变化：\(newDate)")
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
            self.myObject.date = Date()
        }
    }
    
    deinit {
        debugPrint("OtherClass deinit")
    }
}

let obj2 = OtherClass()
