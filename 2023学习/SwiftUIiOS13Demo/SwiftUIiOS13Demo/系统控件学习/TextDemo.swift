//
//  TextDemo.swift
//  SwiftUIiOS13Demo
//
//  Created by fengcaifan on 2023/11/17.
//

import SwiftUI

let kScreenWidth = UIScreen.main.bounds.width

struct TextDemo: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello, World!")
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 20.0)
                .frame(height: 24.0)
                .background(Color.red.opacity(0.6))
            Text("Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!")
                .font(.system(size: 14))
                .padding(.horizontal, 20.0)
                .frame(height: 42.0)
                .background(Color.blue.opacity(0.6))
        }
        .background(Color.orange.opacity(0.6))
        
        Spacer()
            .frame(height: 20.0)
        
        VStack(alignment: .leading) {
            Text("Hello, World!")
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 20.0)
                .frame(height: 24.0, alignment: .leading)
                .background(Color.red.opacity(0.6))
            Text("HelloWorldHello WorldHelloWorldHelloWorldHelloWorld")
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 20.0)
                .frame(height: 42.0, alignment: .leading)
                .background(Color.blue.opacity(0.6))
        }
        .frame(width: kScreenWidth)
        .background(Color.orange.opacity(0.6))
        
        Color.black
            .frame(width: 20, height: 20.0, alignment: .leading)
    }
}

#Preview {
    TextDemo()
}
