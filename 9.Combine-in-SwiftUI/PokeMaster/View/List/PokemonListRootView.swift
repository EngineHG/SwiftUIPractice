//
//  PokemonListRootView.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonListRootView: View {
  @EnvironmentObject var store: Store
  
  var body: some View {
    NavigationView {
      
      if store.appState.pokemonList.loadingStatus == .fail {
        HStack() {
          Image(systemName: "arrow.clockwise")
          Text("Retry")
        }
        .padding(10)
        .foregroundColor(.white)
        .background(Color.gray)
        .cornerRadius(20, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        .onTapGesture {
          self.store.dispatch(.loadPokemons)
        }
        
      } else if store.appState.pokemonList.pokemons == nil {
        Text("Loading...").onAppear {
          self.store.dispatch(.loadPokemons)
        }
      } else {
        PokemonList().navigationBarTitle(Text("宝可梦列表"))
      }
    }
  }
}

struct PokemonListRootView_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store()
    store.appState.pokemonList.loadingStatus = .fail
    return PokemonListRootView().environmentObject(store)
  }
}
