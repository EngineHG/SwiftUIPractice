//
//  SettingRootView.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct SettingRootView: View {
    var body: some View {
      NavigationView {
        SettingView().navigationBarTitle("设置")
      }
    }
}

struct SettingRootView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRootView()
    }
}
