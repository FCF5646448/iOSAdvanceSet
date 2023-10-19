//
//  AbilityViewModel.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/19.
//

import Foundation

struct AbilityViewModel: Identifiable, Codable {
    let ability: Ability
    
    init(ability: Ability) {
        self.ability = ability
    }
    
    var id: Int { ability.id }
    var name: String { ability.names.CN }
    var nameEN: String { ability.names.EN }
    var descriptionText: String { ability.flavorTextEntries.CN.newlineRemoved }
    var descriptionTextEN: String { ability.flavorTextEntries.EN.newlineRemoved }
}

extension AbilityViewModel: CustomDebugStringConvertible {
    var debugDescription: String {
        "AbilityViewModel - \(id) - \(self.name)"
    }
}
