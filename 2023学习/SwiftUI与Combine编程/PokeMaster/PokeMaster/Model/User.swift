//
//  User.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/12/2.
//

import Foundation

struct User: Codable {
    var email: String
    
    var favoritePokemonIDs: Set<Int>
    
    func isFavoritePokemon(id: Int) -> Bool {
        favoritePokemonIDs.contains(id)
    }
}
