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
  case clearCache
  
  //Pokemon List
  case toggleListSelection(index: Int?)
  case togglePanelPresenting(presenting: Bool)
  
  case loadPokemons
  case loadPokemonsDone(result: Result<[PokemonViewModel], AppError>)
  
  case loadAbilities(pokemon: Pokemon)
  case loadAbilitiesDone(result: Result<[AbilityViewModel], AppError>)
  
  case showSafariView(url: URL)
  case closeSafariView
  
  case selectTabIndex(index: AppState.MainTab.Index)
  
  case setFavorite(pokemon: Pokemon)
  
  case showLoginTip
}
