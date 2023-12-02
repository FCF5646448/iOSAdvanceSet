//
//  ContentView.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/18.
//

import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        MainTab().environmentObject(Store())
    }
    
//    let buttonClicked = AnyPublisher<Int, Never>(0)
//    let publisher1 = PassthroughSubject<Int, Never>()
    
//    var body: some View {
//        VStack {
//            PokemonList()
////            PokemonInfoRow(model: .sample(id: 1), expended: false)
////            PokemonInfoRow(model: .sample(id: 21), expended: true)
////            PokemonInfoRow(model: .sample(id: 24), expended: false)
//            
////            Button(action: buttonClicked) {
//                
////            }
//            Button {
//                
//            } label: {
//                Text("test btn")
//                    .font(.system(size: 14, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 100, height: 44)
//                    .background(Color.red)
//                    .cornerRadius(6.0)
//            }
//            
////            Text("按钮点击次数")
////            buttonClicked
////                .scan(0) { value, _ in value + 1}
////                .map { String($0) }
////                .sink { Text("按钮被点击次数，累计\($0)") }
//            Text("按钮点击次数")
////            publisher1.sink { complete in
////                print(complete)
////            } receiveValue: { value in
////                print(value)
////            }
//        }
//        .padding()
//    }
}

#Preview {
    ContentView()
}
