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

class SubscriptionToken {
  var cancellable: AnyCancellable?
  func unseal() { cancellable = nil}
}
extension AnyCancellable {
  func seal(in token: SubscriptionToken) {
    token.cancellable = self
  }
}


struct WriteUserAppCommand: AppCommand {
  let user: User
  
  func execute(in store: Store) {
    try? FileHelper.writeJSON(user, to: .documentDirectory, fileName: "user.json")
  }
}
