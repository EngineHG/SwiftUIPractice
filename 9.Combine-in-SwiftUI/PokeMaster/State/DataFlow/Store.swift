//
//  Store.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/29.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine
import Kingfisher

/*以 Redux 为代表的状态管理和组件通讯架构，在近来的前端开发中很受欢迎。它的基本思想和步骤如下：

将 app 当作一个状态机，状态决定用户界面。

这些状态都保存在一个 Store 对象中，被称为 State。

View 不能直接操作 State，而只能通过发送 Action 的方式，间接改变存储在 Store 中的 State。

Reducer 接受原有的 State 和发送过来的 Action，生成新的 State。

用新的 State 替换 Store 中原有的状态，并用新状态来驱动更新界面。*/
class Store: ObservableObject {
  @Published var appState = AppState()
  
  var disposeBag: [AnyCancellable] = []
  
  init() {
    setupObservers()
  }
  
  private func setupObservers() {
    appState.settings.checker.isEmailValid.sink { isValid in
      self.dispatch(.emailValid(valid: isValid))
    }
    .store(in: &disposeBag)
    
    appState.settings.checker.isRegisterOrLoginValid.sink {
      self.dispatch(.registerOrLoginValid(valid: $0))
    }
    .store(in: &disposeBag)
  }
  
  func dispatch(_ action: AppAction) {
    #if DEBUG
    print("[ACTION]:\(action)")
    #endif
    let result = Store.reduce(state: appState, action: action)
    appState = result.0
    if let command = result.1 {
      #if DEBUG
      print("[COMMAND]:\(command)")
      #endif
      command.execute(in: self)
    }
  }
  
  static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
    var appState = state
    var appCommand: AppCommand?
    
    switch action {
    case .login(email: let email, password: let password):
      if case .requesting(.login) = appState.settings.requestStatus { break }
      appState.settings.requestStatus = .requesting(.login)
      appCommand = LoginAppCommand(email: email, password: password)
      
    case .register(let email, let password):
      if case .requesting(.register) = appState.settings.requestStatus { break }
      appState.settings.requestStatus = .requesting(.register)
      appCommand = RegisterAppCommand(email: email, password: password)
      
    case .accountBehaviorDone(result: let result):
      appState.settings.requestStatus = .none
      switch result {
      case .success(let user):
        appState.settings.loginUser = user
      case .failure(let error):
        appState.settings.loginError = error
      }
    case .logOut:
      appState.settings.loginUser = nil
    case .emailValid(valid: let valid):
      appState.settings.isEmailValid = valid
    case .loadPokemons:
      if appState.pokemonList.loadingStatus == .loading { break }
      appState.pokemonList.loadingStatus = .loading
      appCommand = LoadPokemonsCommand()
    case .loadPokemonsDone(result: let result):
      switch result {
      case .success(let models):
        appState.pokemonList.pokemons = Dictionary(
          uniqueKeysWithValues: models.map { ($0.id, $0) }
        )
        appState.pokemonList.loadingStatus = .done
      case .failure(let error):
        print(error)
        appState.pokemonList.loadingStatus = .fail
      }
    case .registerOrLoginValid(valid: let valid):
      appState.settings.isRegisterOrLoginValid = valid
    case .clearCache:
      appState.settings.loginUser = nil
      appState.pokemonList.pokemons = nil
      ImageCache.default.clearCache()
    case .toggleListSelection(index: let index):
      if appState.pokemonList.expandingIndex == index {
        appState.pokemonList.expandingIndex = nil
      } else {
        appState.pokemonList.expandingIndex = index
      }
    case .loadAbilities(pokemon: let pokemon):
      appCommand = LoadAbilitiesCommand(pokemon: pokemon)
    case .loadAbilitiesDone(result: let result):
      switch result {
      case .success(let vms):
        appState.pokemonList.abilities = Dictionary(uniqueKeysWithValues: vms.map { ($0.id, $0) })
      case .failure(let error):
        print(error)
      }
      
    }
    return (appState, appCommand)
  }
}
