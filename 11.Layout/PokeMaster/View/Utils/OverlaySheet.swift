//
//  OverlaySheet.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/7/13.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import SwiftUI

struct OverlaySheet<Content: View>: View {
  
  @GestureState private var translation = CGPoint.zero
  
  private let isPresented: Binding<Bool>
  private let makeContent: () -> Content
  
  init(isPresented: Binding<Bool>, @ViewBuilder makeContent: @escaping () -> Content) {
    self.isPresented = isPresented
    self.makeContent = makeContent
  }
  
  var body: some View {
    VStack {
      Spacer()
      makeContent()
    }
    .offset(y: (isPresented.wrappedValue ? 0 : UIScreen.main.bounds.height) + max(0, translation.y))
    .animation(.interpolatingSpring(stiffness: 70, damping: 12))
    .edgesIgnoringSafeArea(.bottom)
    .gesture(panelDraggingGesture)
  }
  
  var panelDraggingGesture: some Gesture {
    DragGesture()
      .updating($translation) { current, state, _ in
        state.y = current.translation.height
      }
      .onEnded { state in
        if state.translation.height > 250 {
          self.isPresented.wrappedValue = false
        }
      }
  }
}

extension View {
  ///sheet通用弹窗
  func overlaySheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder makeContent: @escaping () -> Content) -> some View {
    overlay(OverlaySheet(isPresented: isPresented, makeContent: makeContent))
  }
}
