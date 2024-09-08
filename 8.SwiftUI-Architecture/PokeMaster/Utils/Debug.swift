//
//  Extension.swift
//  SwiftUIPractice
//
//  Created by CodeMan on 2021/2/6.
//

import SwiftUI

extension View{
  ///body 被执行时可以打印出 view 的类型：
  ///
  ///     var body: some View {
  ///         VStack { /*... */ }.debug()
  ///     }
  func debug() -> Self{
    #if DEBUG
    print(Mirror(reflecting: self).subjectType)
    #endif
    return self
  }
}
