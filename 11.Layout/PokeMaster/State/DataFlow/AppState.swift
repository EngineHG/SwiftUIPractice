//
//  AppState.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/29.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

struct AppState {
  var settings = Settings()
  var pokemonList = PokemonList()
  var mainTab = MainTab()
}

extension AppState {
  
  struct Settings {
    
    enum Sorting: String, CaseIterable, Codable {
      case id, name, color, favorite
    }
    enum AccountBehavior: CaseIterable {
      case register, login
    }
    enum RequestStatus {
      case none
      case requesting(AccountBehavior)
    }
    
    var isEmailValid: Bool = false
    var isRegisterOrLoginValid: Bool = false
    
    //3.在 struct Settings 中持有一个 class 类型的 checker，这会导致 Settings 的值语义被破坏。不过因为我们的架构中只会有一份有效的状态，我们并不在意值语义和引用语义的区别。
    var checker = AccountChecker()
    
    @UserDefaults(key: .showEnglishName, default: true)
    var showEnglishName: Bool
    @UserDefaults(key: .sorting, default: .id)
    var sorting: Sorting
    @UserDefaults(key: .showFavoriteOnly, default: false)
    var showFavoriteOnly: Bool
    
    @FileStorage(directory: .documentDirectory, fileName: "user.json")
    var loginUser: User?
    
    var requestStatus = RequestStatus.none
    
    //弹框是 UI 的一部分，UI 由 State 驱动。因此，我们考虑在 AppState.Settings 里添加上对应的状态 loginError
    var loginError: AppError?
  }
}

extension AppState.Settings {
  //2.使用一个 class 来持有这些内容，这样一来，我们就可以将变量声明为 @Published，并使用前缀美元符号 $ 来获取 Publisher 了
  class AccountChecker {
    @Published var accountBehavior = AccountBehavior.login
    @Published var email = ""
    @Published var password = ""
    @Published var verifyPassword = ""
    
    //isEmailValid 是一个验证用户输入的 Publisher。我们稍后会订阅它，并用它来更新 UI
    var isEmailValid: AnyPublisher<Bool, Never> {
      let remoteVerify = $email
        .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
        .removeDuplicates()
        .flatMap { email -> AnyPublisher<Bool, Never> in
          let validEmail = email.isValidEmailAddress
          let canSkip = self.accountBehavior == .login
          
          switch (validEmail, canSkip) {
          case (false, _):
            return Just(false).eraseToAnyPublisher()
          case (true, false):
            return EmailCheckingRequest(email: email)
              .publisher
              .eraseToAnyPublisher()
          case (true, true):
            return Just(true).eraseToAnyPublisher()
          }
        }
      
      let emailLocalValid = $email.map { $0.isValidEmailAddress }
      let canSkipRemoteVerify = $accountBehavior.map { $0 == .login }
      
      return Publishers.CombineLatest3(
        emailLocalValid,
        canSkipRemoteVerify,
        remoteVerify
      )
      .map { $0 && ($1 || $2) }
      .eraseToAnyPublisher()
    }
    
    ///密码校验
    var isPasswordValid: AnyPublisher<Bool, Never> {
      $accountBehavior.combineLatest($password, $verifyPassword)
        .map {
          switch $0 {
          case .register:
            return !$1.isEmpty && $2 == $1
          case .login:
            return !$1.isEmpty
          }
        }
        .eraseToAnyPublisher()
    }
    
    ///注册/登录前检验
    var isRegisterOrLoginValid: AnyPublisher<Bool, Never> {
      isEmailValid.combineLatest(isPasswordValid)
        .map { $0 && $1 }
        .eraseToAnyPublisher()
    }
  }
}


extension AppState {
  struct PokemonList {
    
    struct SelectionState {
      var expandingIndex: Int? = nil
      var panelIndex: Int? = nil
      var panelPresented = false
      
      func isExpanding(_ id: Int) -> Bool {
        expandingIndex == id
      }
    }
    
    @FileStorage(directory: .cachesDirectory, fileName: "pokemons.json")
    var pokemons: [Int: PokemonViewModel]?
    
    @FileStorage(directory: .cachesDirectory, fileName: "abilities.json")
    var abilities: [Int: AbilityViewModel]?
    
    var loadingStatus: LoadingStatus = .done
    
    var selectionState = SelectionState()
    
    var searchText: String = ""
    
    var isSFViewActive: (URL?, Bool) = (nil, false)
    
    var needShowLoginTip = false
    
    var allPokemonsByID: [PokemonViewModel] {
      guard let pokemons = pokemons?.values else { return [] }
      let list = pokemons.sorted { $0.id < $1.id }
      if searchText.isEmpty {
        return list
      } else {
        return list.filter { $0.name.contains(searchText) }
      }
    }
    
    func abilityViewModels(for pokemon: Pokemon) -> [AbilityViewModel]? {
      guard let abilities = abilities else { return nil }
      return pokemon.abilities.compactMap { abilities[$0.ability.url.extractedID!] }
    }
  }
}

extension AppState {
  struct MainTab {
    enum Index: Hashable {
      case list, settings
    }
    var selection: Index = .list
  }
}

///加载的状态
enum LoadingStatus {
  case done, loading, fail
}
