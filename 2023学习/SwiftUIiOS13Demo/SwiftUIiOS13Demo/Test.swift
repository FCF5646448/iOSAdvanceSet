//
//  Test.swift
//  SwiftUIiOS13Demo
//
//  Created by fengcaifan on 2023/11/14.
//

import SwiftUI

struct Test: View {
    var describe: some View {
        VStack(alignment: .leading) {
            Text("絆の証を選ぶ")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.black)
//                .padding(.horizontal, 20)
            Text("絆の証を変更できます。未所持のアイテムは購入が必要です。")
                .font(.system(size: 14))
                .foregroundColor(Color.black.opacity(0.7))
//                .padding(.horizontal, 20)
            
        }
        .padding(.horizontal, 20)
//        .fixedSize(horizontal: true, vertical: true)
//        .padding(.horizontal, 20)
    }
    
    var body: some View {
        VStack {
            Color.blue.frame(width: UIScreen.main.bounds.width, height: 200)
            describe
                .frame(width: UIScreen.main.bounds.width, height: 66)
                .background(Color.red)
            Color.blue.frame(width: UIScreen.main.bounds.width, height: 200)
            Color.blue.frame(width: UIScreen.main.bounds.width, height: 300)
        }
        .background(Color.orange)
    }
}

#Preview {
    Test()
}
