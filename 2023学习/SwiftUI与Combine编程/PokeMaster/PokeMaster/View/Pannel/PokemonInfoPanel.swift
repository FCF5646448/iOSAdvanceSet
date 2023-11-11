//
//  PokemonInfoPanel.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/20.
//

import SwiftUI

struct PokemonInfoPanel: View {
    let model: PokemonViewModel
    
    // 技能
    var ability: [AbilityViewModel] {
        AbilityViewModel.sample(pokemonID: model.id)
    }
    
    // 顶部Indicator
    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }
    
    // 详细说明
    var pokemonDescription: some View {
        Text(model.descriptionText)
            .font(.callout)
            .foregroundColor(Color(hex: 0x666666))
            .fixedSize(horizontal: false, vertical: true) // 确保文本能显示全
    }
    
    var body: some View {
        VStack(spacing: 20, content: {
            topIndicator // 顶部指示器
            Header(model: self.model) // 头部
            pokemonDescription // 详情
            Divider()
            AbilityList(model: model, // 技能
                        abilityModels: ability)
        })
        .padding(
            EdgeInsets(top: 12,
                       leading: 30,
                       bottom: 30,
                       trailing: 30)
        )
//        .blurBackground(style: .systemMaterial) // 背景
        .background(Color.red)
        .cornerRadius(20)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    PokemonInfoPanel(model: .sample(id: 1))
}
