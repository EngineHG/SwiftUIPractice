//
//  PokemonList.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/23.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
  
  @State private var expandingIndex: Int?
  
  var body: some View {
    ScrollView {
      HStack {
        Spacer(minLength: 16)
        TextField("请输入搜索内容", text: .constant(""))
      }
      .frame(height: 40)
      .background(Color.gray.opacity(0.3))
      .cornerRadius(20)
      .padding(EdgeInsets(top: 10, leading: 16, bottom: 30, trailing: 16))
      LazyVStack {
        ForEach(PokemonViewModel.all) { pokemon in
          PokemonInfoRow(
            mode: pokemon,
            expanded: self.expandingIndex == pokemon.id
          )
          .onTapGesture {
            withAnimation(
              .spring(
                response: 0.3,
                dampingFraction: 0.5,
                blendDuration: 0
              )
            ){
              if self.expandingIndex == pokemon.id {
                self.expandingIndex = nil
              } else {
                self.expandingIndex = pokemon.id
              }
            }
          }
        }
      }
    }
    .overlay(
      VStack{
        Spacer()
        PokemonInfoPanel(model: .sample(id: 1))
      }
      .edgesIgnoringSafeArea(.bottom)
    )
  }
}

struct PokemonList_Previews: PreviewProvider {
  static var previews: some View {
    PokemonList()
  }
}
