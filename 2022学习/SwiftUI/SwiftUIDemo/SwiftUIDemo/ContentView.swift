//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by fengcaifan on 2022/9/2.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            Text("Turtle Rock")
                .font(.title)
            HStack {
                Text("Joshua Tree National Park").font(.subheadline)
                Spacer()
                Text("Califonia").font(.subheadline)
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
