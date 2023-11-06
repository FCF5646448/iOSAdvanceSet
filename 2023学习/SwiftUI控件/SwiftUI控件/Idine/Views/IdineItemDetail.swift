//
//  IdineItemDetail.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/6.
//

import SwiftUI

struct IdineItemDetail: View {
    // @EnvironmentObject 允许变量在代码中没有初始化值，因为它已经在环境变量中设置了。
    // 有了 @EnvironmentObject 标识后，swiftUI会自动在环境列表中查找类型为Order的变量，并将其赋值给当前属性，如果没找到，则会崩溃。
    // 使用了环境变量的UI，监视到对象的任何更改，在publish时及时刷新UI。
    @EnvironmentObject var order: Order
    
    let item: MenuItem
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) { // 右下角
                Image(item.mainImage)
                    .resizable()
                    .scaledToFit()
                Text("Photo: \(item.photoCredit)")
                    .padding(4)
                    .background(Color.black)
                    .font(.caption)
                    .foregroundColor(.white)
                    .offset(x: -5, y: -5)
            }
            Text(item.description)
                .padding()
            Button("Order This") {
                order.add(item: item)
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline) // title的大小
    }
}

#Preview {
    NavigationStack {
        IdineItemDetail(item: MenuItem.example).environmentObject(Order())
    }
}
