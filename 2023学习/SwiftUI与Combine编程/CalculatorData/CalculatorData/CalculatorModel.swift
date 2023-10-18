//
//  CalculatorModel.swift
//  CalculatorData
//
//  Created by fengcaifan on 2023/10/13.
//

import Foundation
import Combine

class CalculatorModel: ObservableObject {
    /*
    // PassthroughSubject 提供了一个send方法，来通知外界有事件要发生了
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var brain: CalculatorBrain = .left("0") {
        willSet {
            objectWillChange.send()
        }
    }
     */
    
    @Published var brain: CalculatorBrain = .left("0")
    @Published var history: [CalculatorButtonItem] = [] // 记录每一次按下的CalculatorButtonItem
    
    var temporaryKept: [CalculatorButtonItem] = [] // 用来暂存“被回溯”的操作
    
    // 当前滑块显示的index值，这个值是0到totalCount之间的一个数字
    var slidingIndex: Float = 0 {
        didSet {
            keepHistory(upTo: Int(slidingIndex))
        }
    }
    
    // 滑块的最大值，是history和temporaryKept两个数组元素数量的和
    var totalCount: Int {
        history.count + temporaryKept.count
    }
    
    // 将history数组中所记录的操作步骤的描述连接起来，作为履历的输出字符串
    var historyDetail: String {
        history.map { $0.description }.joined()
    }
    
    // 接受具体操作，应用到CalculatorBrain的同时，进行操作记录。
    func apply(_ item: CalculatorButtonItem) {
        brain = brain.apply(item: item) // 应用每一个操作
        history.append(item)
        
        temporaryKept.removeAll() // 如果有新的操作，则将回溯历史清空。
        slidingIndex = Float(totalCount)
    }
    
    // 使用index将整个history分成0..<index和 index..<total，
    // 然后分别赋值给history和temporaryKept。
    // 最好将history里的元素，从第0个开始，按顺序运用到brain中。
    func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "out of index.")
        let total = history + temporaryKept
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        
        brain = history.reduce(CalculatorBrain.left("0"), { result, item in
            result.apply(item: item)
        })
    }
}
