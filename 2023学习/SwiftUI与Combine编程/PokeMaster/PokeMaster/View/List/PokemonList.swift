//
//  PokemonList.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/20.
//

import SwiftUI

struct PokemonList: View {
    
    // 将选中的展开cell移到列表，以确保每次只有一个cell展开
    @State var enpandingIndex: Int?
    @State var searchText: String = ""
    
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
                TextField("搜索", text: $searchText).frame(height: 40).padding(.horizontal, 25)
                ForEach(PokemonViewModel.all) { pokemon in
                    PokemonInfoRow(model: pokemon, 
                                   expended: self.enpandingIndex == pokemon.id
                    ).onTapGesture {
                        withAnimation(
                            .spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)
                        ) {
                            self.enpandingIndex = self.enpandingIndex == pokemon.id ? nil: pokemon.id
                        }
                    }
                }
            }
        }
//        .overlay {
//            VStack {
//                Spacer()
//                PokemonInfoPanel(model: .sample(id: 1))
//            }.edgesIgnoringSafeArea(.bottom)
//        }
    }
}

#Preview {
    PokemonList()
}
