//
//  SwiftUI__App.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/10/31.
//

import SwiftUI

@main
struct SwiftUI__App: App {
    // @StateObject包装器负责在应用程序的整个生命周期中保持对象处于活动状态。
    // 但是使用了环境变量的包装器的类，必须要实现ObservableObject协议。
    // 自我理解：这个协议是用来表明这个类在整个app允许中是被监听的状态
    @StateObject var order = Order()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            IdineMainView()
                .environmentObject(order)
        }
    }
}
