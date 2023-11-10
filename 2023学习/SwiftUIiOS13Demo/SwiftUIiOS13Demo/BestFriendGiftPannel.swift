//
//  BestFriendGiftPannel.swift
//  SwiftUIiOS13Demo
//
//  Created by fengcaifan on 2023/11/9.
//

import SwiftUI

struct Describe: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("絆の証を選ぶ")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundColor(.black.opacity(0.87))
            Text("絆の証を変更できます。未所持のアイテムは購入が必要です。")
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.5))
                .frame(width: 374, alignment: .leading)
        }
    }
}

struct BestFriendGiftPannel: View {
    var body: some View {
        VStack {
            BestFirendView()
                .frame(width: 130, height: 180)
            Describe()
            SegmentControl()
            Button {
                print("按钮被点击")
            } label: {
                Text("使用中")
                    .fontWeight(.semibold)
                    .font(.title)
                    .frame(width: 366, height: 56)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(28)
            }
            Spacer()
        }
    }
}

#Preview {
    BestFriendGiftPannel()
        .frame(maxWidth: .infinity)
}
