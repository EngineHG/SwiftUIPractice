//
//  ActivityIndicatorView.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/30.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import UIKit
import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
  typealias UIViewType = UIActivityIndicatorView
  
  private let style: UIActivityIndicatorView.Style
  
  init(_ style: UIActivityIndicatorView.Style) {
    self.style = style
  }
  
  func makeUIView(context: Context) -> UIActivityIndicatorView {
    let v = UIActivityIndicatorView(style: style)
    v.hidesWhenStopped = true
    return v
  }
  
  func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    uiView.style = self.style
    uiView.startAnimating()
  }
}
