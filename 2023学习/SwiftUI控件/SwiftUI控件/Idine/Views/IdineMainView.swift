//
//  IdineMainView.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/6.
//

import SwiftUI

struct IdineMainView: View {
    var body: some View {
        TabView {
            IdineContentView() // 自定义的View
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
            IdineOrderView() // 自定义的View
                .tabItem {
                    Label("Order", systemImage: "square.and.pencil")
                }
        }
    }
}

#Preview {
    IdineMainView().environmentObject(Order())
}
