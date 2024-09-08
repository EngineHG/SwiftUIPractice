//
//  Settings.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

///“虽然这里我们不会涉及状态处理，不过为了更贴近实际，我们还是先来定义驱动这个 View 的数据。新建 Settings 类型，让它满足 ObservableObject”
class Settings: ObservableObject {
  
  enum AccountBehavior: CaseIterable {
    case register, login
  }
  
  enum Sorting: CaseIterable {
    case id, name, color, favorite
  }
  
  @Published var accountBehavior = AccountBehavior.login
  @Published var email = ""
  @Published var password = ""
  @Published var verifyPassword = ""
  
  @Published var showEnglishName = true
  @Published var sorting = Sorting.id
  @Published var showFavoriteOnly = false
}

extension Settings.Sorting {
  var text: String {
    switch self {
    case .id: return "ID"
    case .name: return "名字"
    case .color: return "颜色"
    case .favorite: return "最爱"
    }
  }
}

extension Settings.AccountBehavior {
  var text: String {
    switch self {
    case .register: return "注册"
    case .login: return "登录"
    }
  }
}
