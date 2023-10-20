//
//  PokemonInfoPanelHeader.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/20.
//

import SwiftUI

extension PokemonInfoPanel {
    struct Header: View {
        let model: PokemonViewModel
        
        var pokemonIcon: some View {
            Image("Pokemon-\(model.id)")
                .resizable()
                .frame(width: 68, height: 68)
        }
        
        var nameSpecies: some View {
            VStack(spacing: 10) {
                VStack {
                    Text(model.name)
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(model.color)
                    
                    Text(model.nameEN)
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .foregroundColor(model.color)
                }
                Text(model.genus)
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
        }
        
        var verticalDivider: some View {
            RoundedRectangle(cornerRadius: 1)
                .frame(width: 1, height: 44)
                .opacity(0.1)
        }
        
        var bodyStatus: some View {
            VStack(alignment: .leading, content: {
                HStack {
                    Text("身高")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(model.height)
                        .font(.system(size: 11))
                        .foregroundColor(model.color)
                }
                HStack {
                    Text("体重")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    Text(model.weight)
                        .font(.system(size: 11))
                        .foregroundColor(model.color)
                }
            })
        }
        
        var typeInfo: some View {
            HStack {
                ForEach(self.model.types) { t in
                    ZStack {
                        RoundedRectangle(cornerRadius: 7).fill(t.color).frame(width: 36, height: 14)
                        Text(t.name)
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        
        var body: some View {
            HStack(spacing: 18, content: {
                pokemonIcon
                nameSpecies
                verticalDivider
                VStack(spacing: 12) {
                    bodyStatus
                    typeInfo
                }
            })
        }
    }
}

#Preview {
    PokemonInfoPanel.Header(model: .sample(id: 1))
}
