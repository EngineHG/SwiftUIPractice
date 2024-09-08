//
//  FlowRectangle.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/7/15.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct FlowRectangle: View {
  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 0) {
        Rectangle()
          .fill(Color.red)
          .frame(height: 0.3 * proxy.size.height)
        HStack(spacing: 0) {
          Rectangle()
            .fill(Color.green)
            .frame(width: 0.4 * proxy.size.width)
          VStack(spacing: 0) {
            Rectangle()
              .fill(Color.blue)
              .frame(height: 0.4 * proxy.size.height)
            Rectangle()
              .fill(Color.yellow)
              .frame(height: 0.3 * proxy.size.height)
          }
        }
      }
    }
  }
}

struct FlowRectangle_Previews: PreviewProvider {
  static var previews: some View {
    GeometryReader { proxy in
      FlowRectangle()
        .frame(width: 0.5 * proxy.size.width, height: 0.5 * proxy.size.height)
    }
  }
}
