//
//  Order.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/6.
//

import SwiftUI

// ObservableObject应该是表示当前类是属于被监听的状态
class Order: ObservableObject {
    // 在KVO底层中，如果一个属性变更，需要在willSet或didSet中增加响应方法。
    // 使用 @Published 则省略了这个步骤。如果多个属性被监听变更，则只需要在对应属性中添加，减少每个属性中加willSet或didSet。
    @Published var items = [MenuItem]()
    
    var total: Int {
        if items.count > 0 {
            return items.reduce(0) { $0 + $1.price }
        } else {
            return 0
        }
    }
    
    func add(item: MenuItem) {
        items.append(item)
    }
    
    func remove(item: MenuItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
}
