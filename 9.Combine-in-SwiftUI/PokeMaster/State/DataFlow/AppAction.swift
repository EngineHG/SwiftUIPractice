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
  case register(email: String, password: String)
  case accountBehaviorDone(result: Result<User, AppError>)
  case logOut
  case emailValid(valid: Bool)
  case registerOrLoginValid(valid: Bool)
  case loadPokemons
  case loadPokemonsDone(result: Result<[PokemonViewModel], AppError>)
  case clearCache
  ///切换cell展开状态
  case toggleListSelection(index: Int?)
  ///技能开始加载
  case loadAbilities(pokemon: Pokemon)
  ///技能加载结束
  case loadAbilitiesDone(result: Result<[AbilityViewModel], AppError>)
}
