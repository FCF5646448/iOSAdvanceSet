//
//  Pokemon.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/18.
//

import Foundation

// Codable: 是编码encodable和解码decodable协议的组合
struct Pokemon: Codable {
    struct `Type`: Codable {
        struct Internal: Codable {
            let name: String
            let url: URL
        }
        
        let slot: Int
        let type: Internal
    }
    
    struct AbilityEntry: Codable, Identifiable {
        struct Internal: Codable {
            let name: String
            let url: URL
        }
        
        let slot: Int
        let ability: Internal
        
        var id: URL { ability.url }
    }
    
    struct Stat: Codable {
        enum StatCase: String, Codable {
            case speed
            case specialDefense = "special-defense"
            case specialAttack = "special-attack"
            case defense
            case attack
            case hp
        }
        
        struct Internal: Codable {
            let name: StatCase
        }
        
        let baseStat: Int
        let stat: Internal
    }
    
    struct SpeciesEntry: Codable {
        let name: String
        let url: URL
    }
    
    let id: Int
    let types: [Type]
    let abilities: [AbilityEntry]
    let stats: [Stat]
    let species: SpeciesEntry
    let height: Int
    let weight: Int
}

// Identifiable 协议提供唯一标识，可以区分同一类型的不同实例
extension Pokemon: Identifiable {}

extension Pokemon: CustomDebugStringConvertible {
    var debugDescription: String {
        "Pokemon - \(id) - \(self.species.name)"
    }
}
