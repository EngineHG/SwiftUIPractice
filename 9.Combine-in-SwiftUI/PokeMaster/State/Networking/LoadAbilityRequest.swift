//
//  LoadAbilityRequest.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/7/13.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

struct LoadAbilityRequest {
  let pokemonAbility: Pokemon.AbilityEntry
  
  var publisher: AnyPublisher<AbilityViewModel, AppError> {
     URLSession.shared
      .dataTaskPublisher(for: pokemonAbility.ability.url)
      .map {
        print(try? JSONSerialization.jsonObject(with: $0.data, options: .allowFragments) as? [String : Any])
        return $0.data
      }
      .decode(type: Ability.self.self, decoder: appDecoder)
      .map { AbilityViewModel(ability: $0) }
      .mapError { AppError.networkingFailed($0) }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
