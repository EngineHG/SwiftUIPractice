//
//  AppError.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/29.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

enum AppError: Error, Identifiable {
  
  var id: String { localizedDescription }
  
  case passwordWrong
}
extension AppError: LocalizedError {
  var localizedDescription: String {
    switch self {
    case .passwordWrong: return "密码错误"
    }
  }
}
