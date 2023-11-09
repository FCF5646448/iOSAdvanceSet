//
//  SwiftUIGrid.swift
//  SwiftUIiOS13Demo
//
//  Created by fengcaifan on 2023/11/9.
//

import SwiftUI

struct TPBestFriendGiftViewCell: View {
//    let model: TPBestFriendGiftModel
    @State private var giftImage: Image?
    @State var isSelected: Bool
    @State var isUsed: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .center) {
                    Image("user2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 60)
                    Spacer().frame(height: 12)
                    Text("星星花束")
                        .fontWeight(.medium)
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.87))
                    Spacer().frame(height: 12)
                    
                    if isUsed {
                        IconText(icon: "clock", text: "xx日期")
                    } else {
                        IconText(icon: "coin", text: "300")
                    }
                }
                .padding()
                if isUsed {
                    Text("使用中")
                        .padding(.horizontal, 4)
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .background(Color.red)
                        .clipShape(CornersRounded(cornerRadius: 8.0, corners: [.bottomLeft, .topRight]))
                        .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                }
            }
            .background(
                isSelected ? Color.yellow.opacity(0.5): Color.clear
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8.0)
                    .inset(by: 0.5)
                    .stroke(isSelected ? Color.red: Color.clear, lineWidth: 1)
            )
            .cornerRadius(8.0)
        }
        .frame(width: 120, height: 146)
    }
}

// 指定圆角的Shape
struct CornersRounded: Shape {
    var cornerRadius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}

struct IconText: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(alignment: .center, spacing: 1.0) {
            Image(icon)
                .resizable()
                .scaledToFit()
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.5))
        }
    }
}


struct Test: View {
    var isSelected: Bool = false
    var isUsed: Bool = false
    
    var body: some View {
        VStack {
            TPBestFriendGiftViewCell(isSelected: isSelected, isUsed: isUsed)
            Button {
//                self.isSelected = !self.isSelected
//                self.isUsed = !self.isUsed
            } label: {
                Text("test btn")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .background(Color.red)
            }
            .cornerRadius(8.0)
            .padding()
        }
    }
}



struct GiftCollectionView: View {
    let data = Array(0..<20)
//    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
//
//    let rows: [GridItem] = Array(repeating: .init(.fixed(146)), count: 2) // 146是每个item的高度
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(0..<data.count, id:\.self) { index in
                        
                    }
                }
//                LazyVGrid(columns: columns, spacing: 7.0) {
//                    ForEach(data, id:\.self) { item in
//                        let isSelected = item == 1
//                        let isUsed = item == 3
//                        TPBestFriendGiftViewCell(isSelected: isSelected, isUsed: isUsed)
//                    }
//                }
//                .padding(.horizontal)
            }
            .frame(maxHeight: 300.0)
            
            /*
            Rectangle()
                .fill(Color.blue)
                .frame(height: 20)
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, spacing: 7.0) {
                    ForEach(data, id:\.self) { item in
                        let isSelected = item == 1
                        let isUsed = item == 3
                        TPBestFriendGiftViewCell(isSelected: isSelected, isUsed: isUsed)
                    }
                }
                .padding(.vertical)
            }
             */
        }
    }
}

#Preview {
    GiftCollectionView()
//    TPBestFriendGiftViewCell(isSelected: true, isUsed: true)
}
