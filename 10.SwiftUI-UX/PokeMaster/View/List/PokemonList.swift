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
  
  private var pokemonList: AppState.PokemonList {
    store.appState.pokemonList
  }
  private var pokemonListBinding: Binding<AppState.PokemonList> {
    $store.appState.pokemonList
  }
  
  var body: some View {
    ScrollView {
      LazyVStack {
        TextField("搜索", text: pokemonListBinding.searchText.animation(nil))
          .frame(height: 40)
          .padding(.horizontal, 25)
        ForEach(pokemonList.allPokemonsByID) { pokemon in
          PokemonInfoRow(
            model: pokemon,
            expanded: pokemonList.selectionState.expandingIndex == pokemon.id
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
    .sheet(isPresented: $store.appState.pokemonList.isSFViewActive.1) {
      SafariView(
        url: pokemonList.isSFViewActive.0!,
        onFinisher: {
          self.store.dispatch(.closeSafariView)
        })
    }
    .alert(isPresented: pokemonListBinding.needShowLoginTip) {
      Alert(
        title: Text("需求账户"),
        primaryButton: Alert.Button.cancel(),
        secondaryButton: Alert.Button.default(Text("登录"), action: {
          self.store.dispatch(.selectTabIndex(index: .settings))
        })
      )
    }
    
  }
}

struct PokemonList_Previews: PreviewProvider {
  static var previews: some View {
    PokemonList()
  }
}
