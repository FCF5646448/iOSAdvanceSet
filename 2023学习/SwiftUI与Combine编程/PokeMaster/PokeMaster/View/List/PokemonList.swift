//
//  PokemonList.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/20.
//

import SwiftUI

struct PokemonList: View {
    var body: some View {
        // List构建一个列表，它接受一个数组，数组中的元素需要遵守Identifiable协议，
        // Identifiable协议有一个id，用于辨别具体的值。这个是UITableView一样。
//        List {
//            ForEach(PokemonViewModel.all) { pokemon in
//                PokemonInfoRow(model: pokemon, expended: false)
//            }
//        }
        ScrollView {
            LazyVStack {
                ForEach(PokemonViewModel.all) { pokemon in
                    PokemonInfoRow(model: pokemon, expended: false)
                }
            }
        }
    }
}

#Preview {
    PokemonList()
}
