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
  case failed(String)
  case networkingFailed(Error)
}
extension AppError: LocalizedError {
  var localizedDescription: String {
    switch self {
    case .passwordWrong: return "密码错误"
    case .networkingFailed(let error):
      return error.localizedDescription
    case .failed(let s):
      return s
    }
  }
}
