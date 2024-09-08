//
//  BlurView.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import UIKit

//struct BlurView: UIViewRepresentable {
//
//  let style: UIBlurEffect.Style
//
//  private let blurView: UIVisualEffectView
//
//  init(style: UIBlurEffect.Style) {
//    self.style = style
//    self.blurView = UIVisualEffectView()
//    print("Init")
//  }
//
//  func makeUIView(context: Context) -> UIView {
//
//    print("makeUIView")
//
//    let view = UIView(frame: .zero)
//    view.backgroundColor = .clear
//
//    return view
//  }
//
//  func updateUIView(_ uiView: UIView, context: Context) {
//    print("Update")
//
//    uiView.subviews.forEach{ $0.removeFromSuperview() }
//    self.blurView.effect = UIBlurEffect(style: style)
//    self.blurView.translatesAutoresizingMaskIntoConstraints = false
//    uiView.addSubview(self.blurView)
//    NSLayoutConstraint.activate(
//      [self.blurView.heightAnchor.constraint(equalTo: uiView.heightAnchor),
//       self.blurView.widthAnchor.constraint(equalTo: uiView.widthAnchor)])
//  }
//}

struct BlurView: UIViewRepresentable {
  typealias UIViewType = UIVisualEffectView
  
  let style: UIBlurEffect.Style
  
  init(style: UIBlurEffect.Style) {
    self.style = style
    print("Init")
  }
  
  func makeUIView(context: Context) -> UIVisualEffectView {
    print("makeUIView")
    let blurView = UIVisualEffectView()
    blurView.translatesAutoresizingMaskIntoConstraints = false
    return blurView
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    print("Update")
    uiView.effect = UIBlurEffect(style: self.style)
  }
}

extension View {
  
  /// 半透明模糊背景
  /// - Parameter style: 模糊类型
  /// - Returns: some View
  func blurBackground(style: UIBlurEffect.Style) -> some View {
    ZStack {
      BlurView(style: style)
      self
    }
  }
}
