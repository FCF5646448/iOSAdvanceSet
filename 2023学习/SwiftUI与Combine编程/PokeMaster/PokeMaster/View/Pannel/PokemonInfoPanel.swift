//
//  PokemonInfoPanel.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/20.
//

import SwiftUI

struct PokemonInfoPanel: View {
    let model: PokemonViewModel
    
    var ability: [AbilityViewModel] {
        AbilityViewModel.sample(pokemonID: model.id)
    }
    
    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }
    
    var pokemonDescription: some View {
        Text(model.descriptionText)
            .font(.callout)
            .foregroundColor(Color(hex: 0x666666))
            .fixedSize(horizontal: false, vertical: true) // 确保文本能显示全
    }
    
    var body: some View {
        VStack(spacing: 20, content: {
            topIndicator
            Header(model: self.model)
            pokemonDescription
            Divider()
            AbilityList(model: model,
                        abilityModels: ability)
        })
        .padding(
            EdgeInsets(top: 12,
                       leading: 30,
                       bottom: 30,
                       trailing: 30)
        )
        .blurBackground(style: .systemMaterial)
//        .background(Color.white)
        .cornerRadius(20)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    PokemonInfoPanel(model: .sample(id: 1))
}
