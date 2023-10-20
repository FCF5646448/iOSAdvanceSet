//
//  PokemonInfoRow.swift
//  PokeMaster
//
//  Created by fengcaifan on 2023/10/19.
//

import SwiftUI

struct PokemonInfoRow: View {
//    let model = PokemonViewModel.sample(id: 1)
    
    let model: PokemonViewModel
    @State var expended: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image("Pokemon-\(model.id)")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4)
                Spacer()
                VStack(alignment: .trailing, content: {
                    Text(model.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text(model.nameEN)
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
            }.padding(.top, 12)
            Spacer()
            HStack(spacing: expended ? 20: -30) {
                Spacer()
                Button(action: {
                    print("fav")
                }, label: {
                    Image(systemName: "star").modifier(ToolButtonModifier())
                })
                Button(action: {
                    print("pannel")
                }, label: {
                    Image(systemName: "chart.bar")
                        .modifier(ToolButtonModifier())
                })
                Button(action: {
                    print("web")
                }, label: {
                    Image(systemName: "info.circle")
                        .modifier(ToolButtonModifier())
                })
            }
            .padding(.bottom, 12)
            .opacity(expended ? 1.0: 0.0)
            .frame(maxHeight: expended ? .infinity: 0)
        }
        .frame(height: expended ? 120: 80)
        .padding(.leading, 23)
        .padding(.trailing, 15)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(model.color, style: StrokeStyle(lineWidth: 4))
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, model.color]),
                            startPoint: .leading,
                            endPoint: .trailing)
                    )
            }
        )
        .padding(.horizontal)
//        .animation(.default)  隐式动画
        .onTapGesture {
            withAnimation( // 显示动画
                .spring(
                    response: 0.55,
                    dampingFraction: 0.425,
                    blendDuration: 0
                )
            ) {
                self.expended.toggle()
            }
        }
    }
}

struct ToolButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}

#Preview {
    VStack {
        PokemonInfoRow(model: .sample(id: 1), expended: false)
        PokemonInfoRow(model: .sample(id: 21), expended: true)
        PokemonInfoRow(model: .sample(id: 24), expended: false)
    }
}
