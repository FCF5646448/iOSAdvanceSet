//
//  SettingRootView.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/23.
//

import SwiftUI

struct SettingRootView: View {
    var body: some View {
        NavigationView {
            SettingView()
                .navigationTitle("设置")
        }
    }
}

#Preview {
    SettingRootView()
}
