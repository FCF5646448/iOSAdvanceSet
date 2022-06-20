import UIKit

var greeting = "@PropertyWrapper"

// ------------------监听打印日志等场景----------------- //
/// 日志监听打印新值。这种情况下，有多少个属性，就需要写多少个set、get
struct LogTest {
    private var _x = 0
    private var _y = 0
    private var _z = 0
    
    var x: Int {
        get { _x }
        set {
            _x = newValue
            print("x new value is \(newValue)")
        }
    }
    
    var y: Int {
        get { _y }
        set {
            _y = newValue
            print("y new value is \(newValue)")
        }
    }
    
    var z: Int {
        get { _z }
        set {
            _z = newValue
            print("z new value is \(newValue)")
        }
    }
}

// -----------------用一个类型进行优化---------------- //
///
struct ConsoleLogged<Value> {
    private var value: Value
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Value {
        get { value }
        set {
            value = newValue
            print("new value is \(newValue)")
        }
    }
}

// 重写
struct LogTest2 {
    private var _x = ConsoleLogged<Int>(wrappedValue: 0)
    private var _y = ConsoleLogged<Int>(wrappedValue: 0)
    private var _z = ConsoleLogged<Int>(wrappedValue: 0)
    
    var x: Int {
        get { _x.wrappedValue }
        set { _x.wrappedValue = newValue }
    }
    
    var y: Int {
        get { _y.wrappedValue }
        set { _y.wrappedValue = newValue }
    }
    
    var z: Int {
        get { _z.wrappedValue }
        set { _z.wrappedValue = newValue }
    }
}

var test = LogTest2()
test.x = 1
test.y = 2
test.z = 3

debugPrint("test2 values: x:\(test.x), y:\(test.y), z:\(test.z)")


// ---------------使用swift @propertyWrapper重写ConsoleLogged-------------- //
/// 注意⚠️：
/// 1、必须使用@propertyWrapper定义
/// 2、@propertyWrapper 最重要的是一定要有一个var wrappedValue名称的变量
@propertyWrapper
struct ConsoleLogged2<Value> {
    private var value: Value
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Value {
        get { value }
        set {
            value = newValue
            print("new value is \(newValue)")
        }
    }
}

// 重写
struct LogTest3 {
    @ConsoleLogged2 var x: Int = 0 // 这个初始化和使用init(wrappedValue: 0)效果是一样的
    @ConsoleLogged2(wrappedValue: 0) var y: Int
    @ConsoleLogged2(wrappedValue: 0) var z: Int
}

var testLog = LogTest3()
testLog.x = 1
testLog.y = 2
testLog.z = 3

// ---------------最简单的属性包装器-------------- //
@propertyWrapper
struct Wrapper<T> {
    var wrappedValue: T
}

struct TestWarpper {
    @Wrapper var x: Int = 0
}

var test2 = TestWarpper()
test2.x = 2
debugPrint(test2.x)


// ---------------项目中的实用案例-----------------//
@propertyWrapper
struct UserDefaultValue<T> {
    private let defalutValue: T?
    private let key: String
    // 注意初始化的默认值，不会放到wrappedValue里
    init(defualtValue: T?, key: String) {
        self.defalutValue = defualtValue
        self.key = key
    }
    
    init(key: String) {
        self.init(defualtValue: nil, key: key)
    }
    
    var wrappedValue: T? {
        get {
            return UserDefaults.standard.value(forKey: key) as? T
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

struct Test3 {
    @UserDefaultValue(defualtValue: 1, key: "wrapper_testValue")
    var testValue: Int?
}

var test3 = Test3()
test3.testValue = 3

print("test userdefault value: \(test3.testValue ?? 0)")
