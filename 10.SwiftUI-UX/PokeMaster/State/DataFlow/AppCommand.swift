//
//  AppCommand.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/29.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

protocol AppCommand {
  
  ///这个协议定义了一个唯一的方法 execute(in:)，它是开始执行副作用的入口。参数 Store 则提供了一个执行后续操作的上下文，让我们可以在副作用执行完毕时，继续发送新的 Action 来更改 app 状态。
  func execute(in store: Store)
}

struct LoginAppCommand: AppCommand {
  let email: String
  let password: String
  
  func execute(in store: Store) {
    let token = SubscriptionToken()
    LoginRequest(email: email, password: password)
      .publisher
      .sink(
        receiveCompletion: { complete in
          if case .failure(let error) = complete {
            store.dispatch(.accountBehaviorDone(result: .failure(error)))
          }
          token.unseal()
        },
        receiveValue: { user in
          store.dispatch(.accountBehaviorDone(result: .success(user)))
        }
      )
      .seal(in: token)
  }
}

struct WriteUserAppCommand: AppCommand {
  let user: User
  
  func execute(in store: Store) {
    try? FileHelper.writeJSON(user, to: .documentDirectory, fileName: "user.json")
  }
}

struct LoadPokemonsCommand: AppCommand {
  
  func execute(in store: Store) {
    let token = SubscriptionToken()
    LoadPokemonRequest.all
      .sink(
        receiveCompletion: { complete in
          if case .failure(let error) = complete {
            store.dispatch(
              .loadPokemonsDone(result: .failure(error))
            )
          }
          token.unseal()
        }, receiveValue: { value in
          store.dispatch(
            .loadPokemonsDone(result: .success(value))
          )
        }
      )
      .seal(in: token)
  }
}

struct RegisterAppCommand: AppCommand {
  let email: String
  let password: String
  func execute(in store: Store) {
    let token = SubscriptionToken()
    RegisterRequest(email: email, password: password)
      .publisher
      .sink(receiveCompletion: { complet in
        if case .failure(let error) = complet {
          store.dispatch(.accountBehaviorDone(result: .failure(error)))
        }
        token.unseal()
      }, receiveValue: { user in
        store.dispatch(.accountBehaviorDone(result: .success(user)))
        token.unseal()
      })
      .seal(in: token)
  }
}

struct LoadAbilitiesCommand: AppCommand {
  let pokemon: Pokemon
  
  func load(pokemonAbility: Pokemon.AbilityEntry, in store: Store) -> AnyPublisher<AbilityViewModel, AppError> {
    if let value = store.appState.pokemonList.abilities?[pokemonAbility.id.extractedID!] {
      return Just(value)
        .setFailureType(to: AppError.self)
        .eraseToAnyPublisher()
    } else {
      return LoadAbilityRequest(pokemonAbility: pokemonAbility).publisher
    }
  }
  
  func execute(in store: Store) {
    let token = SubscriptionToken()
    pokemon.abilities
      .map { load(pokemonAbility: $0, in: store) }
      .zipAll
      .sink(receiveCompletion: { complet in
        if case .failure(let error) = complet {
          store.dispatch(.loadAbilitiesDone(result: .failure(error)))
        }
        token.unseal()
      }, receiveValue: { viewModels in
        store.dispatch(.loadAbilitiesDone(result: .success(viewModels)))
        token.unseal()
      })
      .seal(in: token)
    
  }
}

struct FavoriteCommand: AppCommand {
  let pokemon: Pokemon
  let isFavorite: Bool
  
  func execute(in store: Store) {
    //TODO: 设置收藏的逻辑暂时未写
    
    store.dispatch(.showLoginTip)
    
  }
}

class SubscriptionToken {
  var cancellable: AnyCancellable?
  func unseal() { cancellable = nil}
}
extension AnyCancellable {
  func seal(in token: SubscriptionToken) {
    token.cancellable = self
  }
}
