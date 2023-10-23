//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/23.
//

import SwiftUI

struct PokemonRootView: View {
    var body: some View {
        NavigationView {
            PokemonList().navigationTitle("宝可梦列表")
        }
    }
}

#Preview {
    PokemonRootView()
}
