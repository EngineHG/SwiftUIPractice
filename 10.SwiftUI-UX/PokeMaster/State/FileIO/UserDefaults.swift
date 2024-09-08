//
//  UserDefaults.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/30.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaults<T: Codable> {
  
  private let key: UserDefaultsKey
  private let defaultValue: T
  
  init(key: UserDefaultsKey, default defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
  
  var wrappedValue: T {
    set {
      guard let data = try? JSONEncoder().encode(newValue) else {
        print("\(newValue) encode失败")
        return
      }
      Foundation.UserDefaults.standard.setValue(data, forKey: key.rawValue)
      Foundation.UserDefaults.standard.synchronize()
    }
    get {
      guard let data = Foundation.UserDefaults.standard.data(forKey: key.rawValue),
            let userValue = try? JSONDecoder().decode(T.self, from: data) else { return defaultValue }
      
      return userValue
    }
  }
}

enum UserDefaultsKey: String {
  case showEnglishName
  case sorting
  case showFavoriteOnly
}
