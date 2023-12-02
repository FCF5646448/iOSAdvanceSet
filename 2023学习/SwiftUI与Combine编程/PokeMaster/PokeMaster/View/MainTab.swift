//
//  MainTab.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/11/20.
//

import SwiftUI

struct MainTab: View {
    var body: some View {
        TabView {
            PokemonRootView()
                .tabItem {
                    Image(systemName: "list.bullet.below.rectangle")
                    Text("列表")
                }
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("设置")
                }
        }
        .edgesIgnoringSafeArea(.top) // 不会滚动到刘海屏外部
    }
}

#Preview {
    MainTab()
}
