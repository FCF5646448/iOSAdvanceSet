//
//  ContentView.swift
//  CalculatorData
//
//  Created by fengcaifan on 2023/10/9.
//

import SwiftUI

let scale = UIScreen.main.bounds.width / 414

struct ContentView: View {
    @State private var brain: CalculatorBrain = .left("0")
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text(brain.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24)
                .lineLimit(1)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       alignment: .trailing)
            CalculatorButtonPad(brain: $brain)
                .padding(.bottom)
        }
        .scaleEffect(scale)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
