//
//  PokemonInfoRow.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/22.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct PokemonInfoRow: View {
  
  @EnvironmentObject var store: Store
  
  let model: PokemonViewModel
  ///是否展开
  let expanded: Bool
  
  var body: some View {
    VStack {
      HStack { //图片，名字
        //Image("Pokemon-\(mode.id)")
        KFImage(model.iconImageURL)
          .resizable()
          .frame(width: 50, height: 50)
          .aspectRatio(contentMode: .fit)
          .shadow(radius: 4)
        Spacer() //“在两个 HStack 之间插入了一个 Spacer。这是为了让宝可梦图片名字的 HStack 相对固定，这样在之后的展开/收缩动画中它不会任意移动。其实通过精确计算 frame 高度也可以达到同样的效果，不过加入这个 Spacer 让我们可以用灵活的方式应对今后 cell 高度变化所带来的变动。”
        VStack(alignment: .trailing) {
          Text(model.name)
            .font(.title)
            .fontWeight(.black)
            .foregroundColor(.white)
          Text(model.nameEN)
            .font(.subheadline)
            .foregroundColor(.white)
        }
      }.padding(.top, 12)
      Spacer()
      HStack(spacing: expanded ? 20.0 : -30.0) {
        Spacer()
        Button(action: {
          self.store.dispatch(.setFavorite(pokemon: model.pokemon))
        }) {
          Image(systemName: "star")
            .modifier(ToolButtonModifer())
        }
        Button(action: {
          let target = !self.store.appState.pokemonList.selectionState.panelPresented
          self.store.dispatch(.togglePanelPresenting(presenting: target))
        }) {
          Image(systemName: "chart.bar")
            .modifier(ToolButtonModifer())
        }
        Button(action: {
          self.store.dispatch(.showSafariView(url: model.detailPageURL))
        }) {
          Image(systemName: "info.circle")
            .modifier(ToolButtonModifer())
        }
      }
      .padding(.bottom, 12)
      .opacity(expanded ? 1.0 : 0.0)
      .frame(maxHeight: expanded ? .infinity : 0.0)
    }
    .frame(height: expanded ? 120.0 : 80.0)
    .padding(.leading, 23)
    .padding(.trailing, 15)
    .background(
      ZStack{
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
  }
}

struct PokemonInfoRow_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      PokemonInfoRow(model: .sample(id: 1), expanded: false)
      PokemonInfoRow(model: .sample(id: 21), expanded: true)
      PokemonInfoRow(model: .sample(id: 25), expanded: false)
    }
  }
}

///按钮样式
struct ToolButtonModifer: ViewModifier {
  
  func body(content: Content) -> some View {
    content
      .font(.system(size: 25))
      .foregroundColor(.white)
      .frame(width: 30, height: 30)
  }
}
