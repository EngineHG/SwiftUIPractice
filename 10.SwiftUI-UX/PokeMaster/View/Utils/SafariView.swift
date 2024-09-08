//
//  SafariView.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/7/13.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
 
  let url: URL
  let onFinisher: () -> ()

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeUIViewController(context: Context) -> SFSafariViewController {
    let controller = SFSafariViewController(url: url)
    controller.delegate = context.coordinator
    return controller
  }
  
  func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    
  }
  
  class Coordinator: NSObject, SFSafariViewControllerDelegate {
    let parent: SafariView

    init(_ parent: SafariView) {
      self.parent = parent
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
      parent.onFinisher()
    }
  }
}
