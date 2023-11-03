//
//  SwiftUIStack.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/3.
//

import SwiftUI

struct SwiftUIStack: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Instant Developer")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                    .foregroundColor(.indigo)
                
                Text("Get help from exports in 15 minutes")
            }
//            Image("user1") // 默认使用原生大小展示图片
//            Image("user1")
//                .resizable() // 会让图片拉伸到填满可用区域
//                .scaledToFit() // 按可用区域，进行fit（保持宽高比）
//                .scaledToFill() // 按可用区域，进行fill（拉伸填满）
//                .aspectRatio(contentMode: .fill)
//                .aspectRatio(contentMode: .fit)
            HStack(alignment: .bottom, spacing: 10) {
                Image("user1")
                    .resizable()
                    .scaledToFit()
                Image("user2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image("user3")
                    .resizable()
                    .scaledToFit()
            }
            .padding(.horizontal, 20) // 左右留空隙
            
            Text("Need help with coding problems? Register!")
            
            
            Spacer() // 加入留白视图，它会展开占用垂直堆叠视图中的所有可用空间。从而将上面的VStack顶到顶部
            
            // 垂直方向紧凑型，则按钮水平排列
            if verticalSizeClass == .compact {
                HSignUpButtonGroup()
            } else {
                VSignUpButtonGroup()
            }
        }
        .padding(.top, 30) // 因为Spacer()会将内容顶到贴着灵动岛的位置，所以可以使用padding增加适当间距。
    }
}

#Preview {
    SwiftUIStack()
}

struct HSignUpButtonGroup: View {
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Text("Sign Up")
            }
            .frame(width: 200)
            .padding()
            .foregroundColor(.white)
            .background(Color.indigo)
            .cornerRadius(10)
            
            Button {
                
            } label: {
                Text("Login In")
            }
            .frame(width: 200)
            .padding()
            .foregroundColor(.white)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 1)
                        .stroke(Color.black, style: StrokeStyle(lineWidth: 4))
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.red, .yellow]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
            )
        }
    }
}

struct VSignUpButtonGroup: View {
    var body: some View {
        VStack {
            Button {
                
            } label: {
                Text("Sign Up")
            }
            .frame(width: 200)
            .padding()
            .foregroundColor(.white)
            .background(Color.indigo)
            .cornerRadius(10)
            
            Button {
                
            } label: {
                Text("Login In")
            }
            .frame(width: 200)
            .padding()
            .foregroundColor(.white)
            .background(Color.gray)
            .cornerRadius(10)
        }
    }
}
