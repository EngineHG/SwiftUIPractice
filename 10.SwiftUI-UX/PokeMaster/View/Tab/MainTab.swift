//
//  MainTab.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/29.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct MainTab: View {
  
  @EnvironmentObject var store: Store
  
  private var pokemonList: AppState.PokemonList {
    store.appState.pokemonList
  }
  private var pokemonListBinding: Binding<AppState.PokemonList> {
    $store.appState.pokemonList
  }
  
  var body: some View {
    TabView(selection: $store.appState.mainTab.selection) {
      PokemonListRootView().tabItem {
        Image(systemName: "list.bullet.below.rectangle")
        Text("列表")
      }
      .tag(AppState.MainTab.Index.list)
      SettingRootView().tabItem {
        Image(systemName: "gear")
        Text("设置")
      }
      .tag(AppState.MainTab.Index.settings)
    }
    .edgesIgnoringSafeArea(.top)
    .overlaySheet(isPresented: pokemonListBinding.selectionState.panelPresented) {
      if let selectedPanelIndex = pokemonList.selectionState.panelIndex,
         let pokemons = pokemonList.pokemons,
         let model = pokemons[selectedPanelIndex]{
        PokemonInfoPanel(model: model)
      }
    }
  }
}

struct MainTab_Previews: PreviewProvider {
  static var previews: some View {
    MainTab()
  }
}
