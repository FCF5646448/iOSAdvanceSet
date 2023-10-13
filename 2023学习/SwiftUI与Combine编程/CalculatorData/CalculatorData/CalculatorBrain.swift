//
//  CalculatorBrain.swift
//  CalculatorData
//
//  Created by fengcaifan on 2023/10/9.
//

import Foundation

/*
 将输入的CalculatorButtonItem转化成当前的CalculatorBrain case。
 收到新的输入时，结合当前的状态进行处理。
 left(String)表示只有左侧数值。给定默认状态是只有左侧数值：left("0")
 leftOp: 表示输入了左侧数字 + 计算符号
 leftOpRight：表示输入了算式左侧数字 + 计算符号 + 右侧数字
 error // 输入错误
 */
enum CalculatorBrain {
    case left(String) // 计算器输入算式左侧数字，默认是left("0"),
    case leftOp(left: String, op: CalculatorButtonItem.Op) // 计算器输入了算式左侧数字 + 计算符号
    case leftOpRight(left: String, op: CalculatorButtonItem.Op, right: String) // 计算器输入了算式左侧数字 + 计算符号 + 右侧数字
    case error // 输入或计算结果出现了错误，无法继续
}

extension CalculatorBrain {
    /*
     用于显示的内容。所以会忽略操作等数据。
     根据当前状态来决定显示内容：
     * 左侧数字：则直接显示数字
     * 左侧数字+操作符：也只显示左侧数字
     * 左侧数字+操作符+右侧数字：显示右侧数值
     * error：异常
     */
    var output: String {
        let result: String
        switch self {
        case .left(let left):
            result = left
        case .leftOp(let left,_):
            result = left
        case .leftOpRight(_, _, let right):
            result = right
        case .error:
            return "Error"
        }
        guard let value = Double(result) else {
            return "Error"
        }
        return formatter.string(from: value as NSNumber)!
    }
    
    /* 对外暴露的接口，接收当前输入：
     根据输入的类型，来选取对应的操作
     item类型：
     * 数字类型：调用apply(num: )进行处理
     * 小数点：调用applyDot()进行处理
     * 操作符：调用apply(op: )进行处理
     * 命令符：调用apply(command: )进行处理
     */
    func apply(item: CalculatorButtonItem) -> CalculatorBrain {
        switch item {
        case .digit(let num):
            return apply(num: num)
        case .dot:
            return applyDot()
        case .op(let op):
            return apply(op: op)
        case .command(let command):
            return apply(command: command)
        }
    }
    
    /*
     如果输入的是数字，则需要根据当前状态来对数字进行处理：
     当前状态：
     * 左侧数字：将新数字与已有数字拼接成新字符串。
     * 左侧数字+操作符：正好变成(左侧数字+操作符+右侧数字)，但是右侧没有原数字，所以与"0"结合成新数字字符串。
     * 左侧数字+操作符+右侧数字：依然是左侧数字+操作符+右侧数字，只是右侧数字需要添加小数点，形成新数字字符串。
     * error：直接使用新数字，只是需要与"0"进行结合处理。
     上述之所以需要与"0"结合判断，是因为apply(num:)内部是使用"0"进行判断的（下面雷同）。
     */
    private func apply(num: Int) -> CalculatorBrain {
        switch self {
        case .left(let left):
            return .left(left.apply(num: num))
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".apply(num: num))
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.apply(num: num))
        case .error:
            return .left("0".apply(num: num))
        }
    }
    
    /*
     如果输入的是小数点，则需要根据当前状态来对小数点进行处理：
     当前状态：
     * 左侧数字：判断数字是否已有小数点，没有的话，就拼接在数字右侧，形成新的数字字符串。
     * 左侧数字+操作符：正好变成(左侧数字+操作符+右侧数字)，但是右侧没有原数字，所以结合"0"直接变成"0."。
     * 左侧数字+操作符+右侧数字：依然是左侧数字+操作符+右侧数字，只是右侧数字需要跟已有数字进行拼接，形成新数字。
     * error：直接结合"0"变成"0."。
     注意：applyDot()函数里判断了是否包含小数点，有的话，直接忽略本地的小数点，没有的话，则追加在原数字后面。
     */
    private func applyDot() -> CalculatorBrain {
        switch self {
        case .left(let left):
            return .left(left.applyDot())
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".applyDot())
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.applyDot())
        case .error:
            return .left("0".applyDot())
        }
    }
    
    /*
     如果输入的是操作符，则需要根据当前状态来与操作符结合起来处理：
     当前状态：
     * 左侧数字：如果输入操作符是"+、-、×、÷"，则当前状态就从左侧数字，变成左侧数字+操作符;
               如果输入操作符是"="，则还是保持左侧数字状态。
     * 左侧数字+操作符：如果输入操作符是"+、-、×、÷"，则依旧还是(左侧数字+操作符)，只是就的操作符需要变成新操作符；
                     如果输入操作符是"="，则直接使用（左侧数字+操作符+左侧数字）进行计算，得出结果后，替换掉左侧数字，操作符维持不变。
                     比如原来是"1+"，等号后就是1+1=2，最后变成"2+"；同样的原来是"5*"，相当于5*5=25,最后变成"25*"。
     * 左侧数字+操作符+右侧数字：如果输入操作符是"+、-、×、÷"，则相当于把已有的（左侧数字+操作符+左侧数字）阶段性计算结果，然后将结果与新操作符进行结合，形成新的(左侧数字+操作符)，
                              如果输入操作符是"="，则直接是把已有的（左侧数字+操作符+左侧数字）计算出结果，最后变成（左侧数字）。
     * error：维持原有状态不变。
     注意：完整的左右数值计算是在calculate(l:, r:) -> String函数里。它根据当前操作符进行对应计算，最后返回一个新字符串
     */
    private func apply(op: CalculatorButtonItem.Op) -> CalculatorBrain {
        switch self {
        case .left(let left):
            switch op {
            case .plus, .minus, .divide, .multiply:
                return .leftOp(left: left, op: op)
            case .equal:
                return self
            }
        case .leftOp(let left, let currentOp):
            switch op {
            case .plus, .minus, .divide, .multiply:
                return .leftOp(left: left, op: op)
            case .equal:
                // 如果是1+=，相当于是1+1；同样的5*=，相当于5*5。
                if let result = currentOp.calculate(l: left, r: left) {
                    return .leftOp(left: result, op: currentOp)
                } else {
                    return .error
                }
            }
        case .leftOpRight(let left, let currentOp, let right):
            switch op {
            case .plus, .minus, .divide, .multiply:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .leftOp(left: result, op: op)
                } else {
                    return .error
                }
            case .equal:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .left(result)
                } else {
                    return .error
                }
            }
        case .error:
            return self
        }
    }
    
    /*
     如果输入的是命令，则需要根据命令来做对应处理：
     命令类型：
     * 清零clear：直接回到默认状态。
     * 翻转flip：翻转只是翻转最近的数值，也就是如果当前只有左侧数值，则对左侧数值进行翻转；如果左右都已有数值，则只对右侧数值进行翻转。
     * 百分数percent：和翻转一样，只是对最近数值进行半分化。
     注意：flipped()函数是将数值从正数转成负数，或者相反。percentaged()函数则是将数值除以100，进行百分比化。
     */
    private func apply(command: CalculatorButtonItem.Command) -> CalculatorBrain {
        switch command {
        case .clear:
            return .left("0")
        case .flip:
            switch self {
            case .left(let left):
                return .left(left.flipped())
            case .leftOp(let left, let op):
                return .leftOpRight(left: left, op: op, right: "-0")
            case .leftOpRight(let left, let op, let right):
                return .leftOpRight(left: left, op: op, right: right.flipped())
            case .error:
                return .left("-0")
            }
        case .percent:
            switch self {
            case .left(let left):
                return .left(left.percentaged())
            case .leftOp:
                return self
            case .leftOpRight(let left, let op, let right):
                return .leftOpRight(left: left, op: op, right: right.percentaged())
            case .error:
                return .left("-0")
            }
        }
    }
}

// 这里会处理"1."这样的字符串，最终返回1
var formatter: NumberFormatter {
    let f = NumberFormatter()
    f.minimumFractionDigits = 0 // 小数点后最少0位小数
    f.maximumFractionDigits = 8 // 小数点后最多8位小数
    f.numberStyle = .decimal // 数字十进制样式，且会以逗号作为分组分隔符隔开
    return f
}

extension String {
    // 是否含小数点
    var containsDot: Bool {
        return contains(".")
    }
    
    // 是否负数
    var startWithNegative: Bool {
        return starts(with: "-")
    }
    
    // 数字结合
    func apply(num: Int) -> String {
        return self == "0" ? "\(num)": "\(self)\(num)" // 如果当前是"0",则使用新的数字替换，否则拼接在后面
    }
    
    // 与小数点结合
    func applyDot() -> String {
        return containsDot ? self: "\(self)."
    }
    
    /// 翻转：负数——>正数，正数——>负数
    func flipped() -> String {
        if startWithNegative {
            var s = self
            s.removeFirst()
            return s
        } else {
            return "-\(self)"
        }
    }
    
    /// 百分数
    func percentaged() -> String {
        return String(Double(self)! / 100)
    }
}

extension CalculatorButtonItem.Op {
    // 两数计算
    func calculate(l: String, r: String) -> String? {
        guard let left = Double(l), let right = Double(r) else {
            return nil
        }
        let result: Double?
        switch self {
        case .plus:
            result = left + right
        case .minus:
            result = left - right
        case .divide:
            result = right == 0 ? nil : left / right
        case .multiply:
            result = left * right
        case .equal:
            fatalError()
        }
        return result.map { String($0) }
    }
}


//typealias CalculatorState = CalculatorBrain
//typealias CalculatorStateAction = CalculatorButtonItem
//
//struct Reducer {
//    static func reduce(state: CalculatorState,
//                       action: CalculatorStateAction) -> CalculatorState {
//        return state.apply(item: action)
//    }
//}
