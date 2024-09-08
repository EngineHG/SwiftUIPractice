//
//  PokemonInfoPanelAbilityList.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/23.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

extension PokemonInfoPanel{
  struct AbilityList: View {
    let model: PokemonViewModel
    let abilityModels: [AbilityViewModel]?
    
    var body: some View {
      VStack(alignment: .leading, spacing: 12) {
        Text("技能")
          .font(.headline)
          .fontWeight(.bold)
        if let abilityModels = abilityModels {
          ForEach(abilityModels) { ability in
            Text(ability.name)
              .font(.subheadline)
              .foregroundColor(self.model.color)
            Text(ability.descriptionText)
              .font(.footnote)
              .foregroundColor(Color(hex: 0xAAAAAA))
              .fixedSize(horizontal: false, vertical: true)
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

struct AbilityList_Previews: PreviewProvider {
    static var previews: some View {
      PokemonInfoPanel.AbilityList(model: .sample(id: 1), abilityModels: AbilityViewModel.sample(pokemonID: 1))
        .preferredColorScheme(.dark)
    }
}
