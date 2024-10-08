//
//  SettingView.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

///设置页面
struct SettingView: View {
  
  @EnvironmentObject var store: Store
  var settingsBinding: Binding<AppState.Settings> {
    $store.appState.settings
  }
  var settings: AppState.Settings {
    store.appState.settings
  }
  
  var body: some View {
    Form{
      accountSection
      optionSection
      actionSection
    }
    .alert(item: settingsBinding.loginError) { error in
      Alert(title: Text(error.localizedDescription))
    }
  }
  
  var accountSection: some View {
    Section(header: Text("账户")) {
      if settings.loginUser == nil {
        Picker(selection: settingsBinding.checker.accountBehavior, label: Text("")) {
          ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
            Text($0.text)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        TextField("电子邮箱", text: settingsBinding.checker.email)
          .foregroundColor(settings.isEmailValid ? .green : .red)
        SecureField("密码", text: settingsBinding.checker.password)
        if settings.checker.accountBehavior == .register {
          SecureField("确认密码", text: settingsBinding.checker.verifyPassword)
        }
        if case .requesting(let behavior) = settings.requestStatus {
          HStack {
            ActivityIndicatorView(.medium)
            Text(
              { () -> String in
                switch behavior {
                case .login:
                  return "登录中..."
                case .register:
                  return "注册中..."
                }
              }()
            )
          }
        } else if case .none = settings.requestStatus {
          registerOrLoginBtn
        }
      } else {
        Text(settings.loginUser!.email)
        Button("注销") {
          self.store.dispatch(.logOut)
        }
      }
    }
  }
  
  var optionSection: some View {
    Section(header: Text("选项")) {
      Toggle(isOn: settingsBinding.showEnglishName, label: {
        Text("显示英文名")
      })
      Picker(selection: settingsBinding.sorting, label: Text("排序方式"), content: {
        ForEach(AppState.Settings.Sorting.allCases, id: \.self) {
          Text($0.text)
        }
      })
      Toggle(isOn: settingsBinding.showFavoriteOnly, label: {
        Text("只显示收藏")
      })
    }
  }
  
  var actionSection: some View {
    Section{
      Button("清空缓存") {
        store.dispatch(.clearCache)
      }
      .foregroundColor(.red)
    }
  }
  
  ///注册/登录按钮
  var registerOrLoginBtn: some View {
    Button(settings.checker.accountBehavior.text) {
      switch settings.checker.accountBehavior {
      case .register:
        self.store.dispatch(.register(email: self.settings.checker.email, password: self.settings.checker.password))
      case .login:
        self.store.dispatch(
          .login(email: self.settings.checker.email, password: self.settings.checker.password)
        )
      }
    }
    .disabled(!settings.isRegisterOrLoginValid)
  }
}

struct SettingView_Previews: PreviewProvider {
  static var previews: some View {
    let store = Store()
    store.appState.settings.sorting = .id
    return SettingView().environmentObject(store)
  }
}

extension AppState.Settings.Sorting {
  var text: String {
    switch self {
    case .id: return "ID"
    case .name: return "名字"
    case .color: return "颜色"
    case .favorite: return "最爱"
    }
  }
}

extension AppState.Settings.AccountBehavior {
  var text: String {
    switch self {
    case .register: return "注册"
    case .login: return "登录"
    }
  }
}
