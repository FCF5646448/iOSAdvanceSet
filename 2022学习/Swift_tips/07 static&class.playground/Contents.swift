import UIKit

var greeting = "static vs class"

enum TestEnum {
    // 存储属性
    static var param: Int = 0
    
    // 计算属性
    static var param2: Int {
        return Self.param
    }
    
//    class var param2: Int = 0 // error: Class properties are only allowed within classes; use 'static' to declare a static property
}

struct TestStruct {
    // 存储属性
    static var param: Int = 0
//    class var param2: Int = 0 // error: Class properties are only allowed within classes; use 'static' to declare a static property
    
    // 计算属性
    static var param2: Int {
        return Self.param
    }
}

class TestClass {
    static var param: Int = 0
    // 计算属性
    static var param2: Int {
        return Self.param
    }
    
//    class var param3: Int = 0 error: Class stored properties not supported in classes; did you mean 'static'?
    
    class var param4: Int {
        return Self.param2
    }
}
