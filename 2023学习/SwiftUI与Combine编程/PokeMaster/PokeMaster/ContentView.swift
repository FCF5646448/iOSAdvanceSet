//
//  ContentView.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            PokemonList()
//            PokemonInfoRow(model: .sample(id: 1), expended: false)
//            PokemonInfoRow(model: .sample(id: 21), expended: true)
//            PokemonInfoRow(model: .sample(id: 24), expended: false)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
