//
//  Store.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/29.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

/*以 Redux 为代表的状态管理和组件通讯架构，在近来的前端开发中很受欢迎。它的基本思想和步骤如下：

将 app 当作一个状态机，状态决定用户界面。

这些状态都保存在一个 Store 对象中，被称为 State。

View 不能直接操作 State，而只能通过发送 Action 的方式，间接改变存储在 Store 中的 State。

Reducer 接受原有的 State 和发送过来的 Action，生成新的 State。

用新的 State 替换 Store 中原有的状态，并用新状态来驱动更新界面。*/
class Store: ObservableObject {
  @Published var appState = AppState()
  
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
      guard !appState.settings.loginRequesting else { break }
      appState.settings.loginRequesting = true
      appCommand = LoginAppCommand(email: email, password: password)
      
    case .accountBehaviorDone(result: let result):
      appState.settings.loginRequesting = false
      switch result {
      case .success(let user):
        appState.settings.loginUser = user
      case .failure(let error):
        appState.settings.loginError = error
      }
    case .logOut:
      appState.settings.loginUser = nil
    }
    return (appState, appCommand)
  }
}
