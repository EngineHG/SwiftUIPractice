//
//  User.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/29.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

struct User: Codable {
  var email: String
  var favoritePokemonIDs: Set<Int>
  
  func isFavoritePokemon(id: Int) -> Bool {
    favoritePokemonIDs.contains(id)
  }
}
