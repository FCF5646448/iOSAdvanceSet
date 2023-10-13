//
//  CalculatorModel.swift
//  CalculatorData
//
//  Created by fengcaifan on 2023/10/13.
//

import Foundation
import Combine

class CalculatorModel: ObservableObject {
    // PassthroughSubject 提供了一个send方法，来通知外界有事件要发生了
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var brain: CalculatorBrain = .left("0") {
        willSet {
            objectWillChange.send()
        }
    }
}
