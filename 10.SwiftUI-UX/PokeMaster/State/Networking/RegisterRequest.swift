//
//  RegisterRequest.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/7/9.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

struct RegisterRequest {
  let email: String
  let password: String
  
  var publisher: AnyPublisher<User, AppError> {
    Future { promise in
      DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
        if password.count >= 3 {
          let user = User(email: email, favoritePokemonIDs: [])
          promise(.success(user))
        } else {
          promise(.failure(AppError.failed("密码长度不能少于3位")))
        }
      }
    }
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }
}
