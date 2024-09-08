//
//  LoginRequest.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/29.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

struct LoginRequest {
  let email: String
  let password: String
  
  var publisher: AnyPublisher<User, AppError> {
    Future { promise in
      DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
        if self.password == "123456" {
          let user = User(email: self.email, favoritePokemonIDs: [])
          promise(.success(user))
        } else {
          promise(.failure(.passwordWrong))
        }
      }
    }
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }
}
