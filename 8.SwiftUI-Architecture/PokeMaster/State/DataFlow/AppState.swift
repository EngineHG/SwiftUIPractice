//
//  AppState.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/29.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

struct AppState {
  var settings = Settings()
}

extension AppState {
  struct Settings {
    enum Sorting: String, CaseIterable, Codable {
      case id, name, color, favorite
    }
    enum AccountBehavior: CaseIterable {
      case register, login
    }
    
    var accountBehavior = AccountBehavior.login
    var email = ""
    var password = ""
    var verifyPassword = ""
    
    @UserDefaults(key: .showEnglishName, default: true)
    var showEnglishName: Bool
    @UserDefaults(key: .sorting, default: .id)
    var sorting: Sorting
    @UserDefaults(key: .showFavoriteOnly, default: false)
    var showFavoriteOnly: Bool
    
    @FileStorage(directory: .documentDirectory, fileName: "user.json")
    var loginUser: User?
    
    var loginRequesting = false
    
    //弹框是 UI 的一部分，UI 由 State 驱动。因此，我们考虑在 AppState.Settings 里添加上对应的状态 loginError
    var loginError: AppError?
  }
}

extension AppState {
  
}
