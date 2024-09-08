//
//  PokemonListRootView.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonListRootView: View {
    var body: some View {
      NavigationView {
        PokemonList().navigationBarTitle(Text("宝可梦列表"))
      }
    }
}

struct PokemonListRootView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListRootView()
    }
}
