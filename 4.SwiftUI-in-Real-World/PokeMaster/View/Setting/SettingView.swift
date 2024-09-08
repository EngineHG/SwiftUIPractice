//
//  SettingView.swift
//  PokeMaster
//
//  Created by huangguojian on 2021/6/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct SettingView: View {
  
  @ObservedObject var settings = Settings()
  
  var body: some View {
    Form{
      accountSection
      optionSection
      actionSection
    }
  }
  
  var accountSection: some View {
    Section(header: Text("账户")) {
      Picker(selection: $settings.accountBehavior, label: Text("")) {
        ForEach(Settings.AccountBehavior.allCases, id: \.self) {
          Text($0.text)
        }
      }
      .pickerStyle(SegmentedPickerStyle())
      TextField("电子邮箱", text: $settings.email)
      SecureField("密码", text: $settings.password)
      if settings.accountBehavior == .register {
        SecureField("确认密码", text: $settings.verifyPassword)
      }
      Button(settings.accountBehavior.text) {
        print("登录/注册")
      }
    }
  }
  
  var optionSection: some View {
    Section(header: Text("选项")) {
      Toggle(isOn: $settings.showEnglishName, label: {
        Text("显示英文名")
      })
      Picker(selection: $settings.sorting, label: Text("排序方式"), content: {
        ForEach(Settings.Sorting.allCases, id: \.self) {
          Text($0.text)
        }
      })
      Toggle(isOn: $settings.showFavoriteOnly, label: {
        Text("只显示收藏")
      })
      
    }
  }
  
  var actionSection: some View {
    Section{
      Button("清空缓存") {
        print("清空缓存")
      }
      .foregroundColor(.red)
    }
  }
}

struct SettingView_Previews: PreviewProvider {
  static var previews: some View {
    SettingView()
  }
}
