//
//  IdineContentView.swift
//  SwiftUI控件
//
//  Created by fengcaifan on 2023/11/6.
//

import SwiftUI

struct IdineContentView: View {
    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    
    var body: some View {
        NavigationView { // 注意导航栏的title是在子视图里设置。这里也同样可以使用NavigationStack
            List {
                ForEach(menu) { section in
                    Section(header: Text(section.name)) { // 类似UITableView的SectionHeader
                        ForEach(section.items) { item in
                            // 点击跳转，会进入一个新的页面,NavigationLink的结构类似Button
                            NavigationLink { //  这里是push出来的新视图
                                IdineItemDetail(item: item)
                            } label: {
                                IdineItemRow(item: item)
                                // 这里是点击视图。
                            }
                        }
                    }
                }
            }
            .navigationTitle("Menu")
            .listStyle(.grouped) // 类似TableView的group
        }
    }
}

#Preview {
    IdineContentView()
}
