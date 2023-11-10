//
//  BestFirendView.swift
//  SwiftUIiOS13Demo
//
//  Created by fengcaifan on 2023/11/9.
//

import SwiftUI

struct HeadView: View {
    var body: some View {
        ZStack {
            Image("user1")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
        }
    }
}

struct BestFirendView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Image("bestFriendBg")
                .resizable()
                .scaledToFit()
            Text("グラ友plus")
                .font(.system(size: 13))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .offset(y: 5.0)
            
            Color.white.opacity(0.6)
                .frame(width: 98, height: 54)
                .cornerRadius(16)
                .offset(y: 98.0)
            
            VStack(spacing: 4.0) {
                HeadView()
                    .frame(width: 40, height: 40)
                Text("さやかささやかやか")
                    .font(.system(size: 12))
                    .frame(width: 86.0)
                    .lineLimit(1)
                    
            }
            .offset(y: 77.0)
        }
    }
}

#Preview {
    BestFirendView().frame(width: 130, height: 180)
}
