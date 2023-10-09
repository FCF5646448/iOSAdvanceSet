//
//  CalculatorBrain.swift
//  CalculatorData
//
//  Created by fengcaifan on 2023/10/9.
//

import Foundation

enum CalculatorBrain {
    case left(String) // 计算器输入算式左侧数字
    case leftOp(left: String, op: CalculatorButtonItem.Op) // 计算器输入了算式左侧数字 + 计算符号
    case leftOpRight(left: String, op: CalculatorButtonItem.Op, right: String) // 计算器输入了算式左侧数字 + 计算符号 + 右侧数字
    case error // 输入或计算结果出现了错误，无法继续
    
}

extension CalculatorBrain {
    var output: String { // 用于显示的内容。所以会忽略操作等数据。
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
    var containsDot: Bool {
        return contains(".")
    }
    
    var startWithNegative: Bool {
        return starts(with: "-")
    }
    
    func apply(num: Int) -> String {
        return self == "0" ? "\(num)": "\(self)\(num)" // 如果当前是"0",则使用新的数字替换，否则拼接在后面
    }
    
    func applyDot() -> String {
        return containsDot ? self: "\(self)."
    }
    
    func flipped() -> String {
        if startWithNegative {
            var s = self
            s.removeFirst()
            return s
        } else {
            return "-\(self)"
        }
    }
    
    func percentaged() -> String {
        return String(Double(self)! / 100)
    }
}

extension CalculatorButtonItem.Op {
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
