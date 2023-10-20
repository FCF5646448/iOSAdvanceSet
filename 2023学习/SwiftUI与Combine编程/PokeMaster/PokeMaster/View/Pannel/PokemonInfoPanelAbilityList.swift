//
//  PokemonInfoPanelAbilityList.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/20.
//

import SwiftUI

extension PokemonInfoPanel {
    struct AbilityList: View {
        let model: PokemonViewModel
        let abilityModels: [AbilityViewModel]?
        
        var body: some View {
            VStack(alignment: .leading, content: {
                Text("技能")
                    .font(.headline)
                    .fontWeight(.bold)
                if let abilityModels = abilityModels {
                    ForEach(abilityModels) { ability in
                        Text(ability.name)
                            .font(.subheadline)
                            .foregroundColor(self.model.color)
                        Text(ability.descriptionText)
                            .font(.footnote)
                            .foregroundColor(Color(hex: 0xAAAAAA))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            })
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    PokemonInfoPanel.AbilityList(model: .sample(id: 1), abilityModels: nil)
}
