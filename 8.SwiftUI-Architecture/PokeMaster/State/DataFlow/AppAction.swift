//
//  AppAction.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/29.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

enum AppAction {
  case login(email: String, password: String)
  case accountBehaviorDone(result: Result<User, AppError>)
  case logOut
}
