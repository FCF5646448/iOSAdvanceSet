import UIKit
import Foundation

var greeting = "正则表达式"

struct RegexHelper {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
}

let mailPattern =
"^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
let matcher: RegexHelper
do {
    matcher = try RegexHelper(mailPattern)
}
let maybeMailAddress = "onev@onevcat.com"
if matcher.match(maybeMailAddress) {
    print("有效的邮箱地址")
}

// 重载操作符
precedencegroup MatchPrecedence {
    associativity: none
    higherThan: DefaultPrecedence
}

infix operator =~: MatchPrecedence

func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try RegexHelper(rhs).match(lhs)
    } catch _ {
        return false
    }
}

if "onev@onevcat.com" =~
    "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$" {
    print("有效的邮箱地址")
}

//--------------模式匹配------------
// switch 使用的是模式匹配
// 判等类型
let password = "akfuv(3"
switch password {
case "akfuv(3": print("密码通过")
default: print("验证失败")
}
// Optional
let num: Int? = nil
switch num {
case nil: print("没有值")
default: print("\(num!)")
}
// 范围
let x = 0.5
switch x {
case -1.0...1.0: print("区间内")
default: print("区间外")
}

// 重载一个可以接收NSRegularExpresion的类型
func ~=(pattern: NSRegularExpression, input: String) -> Bool {
    return pattern.numberOfMatches(in: input,
                                   options: [],
                                   range: NSRange(location: 0, length: input.count)) > 0
}

// 再重载一个将String转成NSRegularExpression的操作符
prefix operator ~/
prefix func ~/(pattern: String) -> NSRegularExpression? {
    return (try? NSRegularExpression(pattern: pattern, options: [])) ?? nil
}

// 使用
let contact = ("http://www.baidu.com", "fcf@gmail.com")
if let siteRegex: NSRegularExpression = ~/"^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$",
   let mailRegex: NSRegularExpression =  ~/"^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$" {
    switch contact {
    case (siteRegex, mailRegex):
        print("同时拥有有效的网站和邮箱")
    case (_, mailRegex):
        print("只有有效的邮箱")
    case (siteRegex, _):
        print("只有有效的网站")
    default:
        print("啥都没有")
    }
}



