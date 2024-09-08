//
//  PokemonInfoPanel.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/23.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonInfoPanel: View {
  
  let model: PokemonViewModel
  @State var darkBlur = true
  
  var abilities: [AbilityViewModel] {
    AbilityViewModel.sample(pokemonID: model.id)
  }
  
  var body: some View {
    VStack(spacing: 20) {
      Button("切换模糊效果") {
        self.darkBlur.toggle()
      }
      topIndicator
      Header(model: model)
      pokemonDescription
      Divider()
      AbilityList(model: model, abilityModels: abilities)
    }
    .padding(EdgeInsets(top: 12, leading: 30, bottom: 30, trailing: 30))
    //.background(Color.white)
    .blurBackground(style: self.darkBlur ? .systemMaterialDark : .systemMaterial)
    .cornerRadius(20)
    .fixedSize(horizontal: false, vertical: true)
  }
  
  private var topIndicator: some View {
    RoundedRectangle(cornerRadius: 3)
      .frame(width: 40, height: 6)
      .opacity(0.2)
  }
  private var pokemonDescription: some View {
    Text(model.descriptionText)
      .font(.callout)
      .foregroundColor(Color(hex: 0x666666))
      .fixedSize(horizontal: false, vertical: true)
  }
}

struct PokemonInfoPanel_Previews: PreviewProvider {
  static var previews: some View {
    PokemonInfoPanel(model: .sample(id: 1))
      .preferredColorScheme(.dark)
//    PokemonInfoPanel.Header(model: .sample(id: 1))
  }
}

extension PokemonInfoPanel {
  struct Header: View {
    let model: PokemonViewModel
    
    var body: some View {
      HStack(spacing: 18) {
        pokemonIcon
        nameSpecies
        verticalDivider
        VStack(spacing: 12) {
          bodyStatus
          typeInfo
        }
      }
    }
    
    var pokemonIcon: some View {
      Image("Pokemon-\(model.id)")
        .resizable()
        .frame(width: 68, height: 68)
    }
    var nameSpecies: some View {
      VStack{
        Text(model.name)
          .font(.system(size: 22, weight: .bold))
          .foregroundColor(model.color)
        Text(model.nameEN)
          .font(.system(size: 13, weight: .bold))
          .foregroundColor(model.color)
        Spacer()
          .frame(height: 10)
        Text(model.genus)
          .font(.system(size: 13, weight: .bold))
          .foregroundColor(.gray)
      }
    }
    var verticalDivider: some View {
      Spacer()
        .frame(width: 1, height: 44)
        .background(Color.gray)
    }
    var bodyStatus: some View {
      VStack(alignment: .leading) {
        ForEach([("身高", model.height), ("体重", model.weight)], id: \.self.0) {  info in
          HStack {
            Text(info.0)
              .foregroundColor(.gray)
            Text(info.1)
              .foregroundColor(model.color)
          }
          .font(.system(size: 11))
        }
      }
    }
    var typeInfo: some View {
      HStack{
        ForEach(model.types) { type in
          Text(type.name)
            .font(.system(size: 10))
            .foregroundColor(.white)
            .frame(width: 36, height: 14)
            .background(type.color)
            .cornerRadius(7)
        }
      }
    }
  }
}
