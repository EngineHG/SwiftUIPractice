//
//  PokemonList.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/23.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
  
  @EnvironmentObject var store: Store
  
  var body: some View {
    ScrollView {
      LazyVStack {
        TextField("搜索", text: $store.appState.pokemonList.searchText.animation(nil))
          .frame(height: 40)
          .padding(.horizontal, 25)
        ForEach(store.appState.pokemonList.allPokemonsByID) { pokemon in
          PokemonInfoRow(
            mode: pokemon,
            expanded: store.appState.pokemonList.expandingIndex == pokemon.id
          )
          .onTapGesture {
            withAnimation(
              .spring(
                response: 0.3,
                dampingFraction: 0.5,
                blendDuration: 0
              )
            ){
              self.store.dispatch(.toggleListSelection(index: pokemon.id))
              self.store.dispatch(.loadAbilities(pokemon: pokemon.pokemon))
            }
          }
        }
      }
      Spacer().frame(height: 8)
    }
//    .overlay(
//      VStack{
//        Spacer()
//        PokemonInfoPanel(model: .sample(id: 1))
//      }
//      .edgesIgnoringSafeArea(.bottom)
//    )
  }
}

struct PokemonList_Previews: PreviewProvider {
  static var previews: some View {
    PokemonList()
  }
}
