//
//  BindingTest.swift
//  SwiftUIiOS13Demo
//
//  Created by fengcaifan on 2023/11/30.
//

import SwiftUI
import Combine

class TestModel: ObservableObject {
    // PassthroughSubject 提供了一个send方法，来通知外界有事件要发生了
//    let objectWillChange = PassthroughSubject<Void, Never>()
//    
//    var count: Int = 0 {
//        willSet {
//            objectWillChange.send()
//        }
//    }
    
    @Published var count: Int = 0
    @Published var count2: Int = 0
}

struct BindingSub2View: View {
    let title: String
    @EnvironmentObject var model2: TestModel
    
    var body: some View {
        Text("\(title) count: \(model2.count)")
        Button("\(title) count: \(model2.count)") {
            model2.count += 1
        }
    }
}


struct BindingSubView: View {
    let title: String
    @Binding var count: Int
    
    var body: some View {
        Text("\(title) count: \(count)")
        Button("\(title) count: \(count)") {
            count += 1
        }
        
        BindingSub2View(title: "C视图")
    }
}

struct BindingTestView: View {
    @State private var count = 0
    @ObservedObject var model = TestModel()
    @EnvironmentObject var model2: TestModel
    
    var body: some View {
        Text("TestView count: \(count)")
        Button("Tap A count: \(count)") {
            count += 1
        }
        BindingSubView(title: "BindingTest", count: self.$count)
        
        Text("TestView model.count: \(model.count)")
        BindingSubView(title: "modelTest",
                       count: self.$model.count)
        
        Text("Environment model.count: \(model2.count)")
        BindingSubView(title: "Environment modelTest",
                       count: self.$model2.count)
    }
}


#Preview {
    BindingTestView().environmentObject(TestModel())
}
