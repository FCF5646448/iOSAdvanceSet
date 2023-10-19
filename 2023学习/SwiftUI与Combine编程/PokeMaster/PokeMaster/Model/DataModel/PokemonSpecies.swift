//
//  PokemonSpecies.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/18.
//

import Foundation
import SwiftUI

struct PokemonSpecies: Codable {
    struct Color: Codable {
        enum Name: String, Codable {
            case black, blue, brown, gray, green, pink, purple, red, white, yellow
            
            var color: SwiftUI.Color {
                SwiftUI.Color("pokemon-\(rawValue)")
            }
        }
        let name: Name
    }
    
    struct Name: Codable, LanguageTextEntry {
        let language: Language
        let name: String
        
        var text: String { name }
    }
    
    struct FlavorTextEntry: Codable, LanguageTextEntry {
        let language: Language
        let flavorText: String
        
        var text: String { flavorText }
    }
    
    struct Genus: Codable, LanguageTextEntry {
        let language: Language
        let genus: String
        
        var text: String { genus }
    }
    
    let color: Color
    let names: [Name]
    let genera: [Genus]
    let flavorTextEntries: [FlavorTextEntry]
}
