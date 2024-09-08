//
//  Helpers.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/08/20.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}

extension URL {
    var extractedID: Int? {
        Int(lastPathComponent)
    }
}

extension String {
    var newlineRemoved: String {
        return split(separator: "\n").joined(separator: " ")
    }

    var isValidEmailAddress: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

let appDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

let appEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    return encoder
}()


import Combine
/*
“在本书写作时，Combine 里只提供了 Zip，Zip3 和 Zip4 三种方式，最多可以对四个 Publisher 做 zip 操作，这显然没有办法满足我们的要求。我们可以通过自定义一个符合 Publisher 协议的 ZipAll 类型，来把一个 Publisher 序列进行合并。但是本书中我们没有提及如何自定义 Publisher 的内容，相关的话题超出了本书的范围。在示例 app 里，我们用一种相对不那么优雅的方式，来把 zip 逐渐合并，来“模拟”出 zipAll 的行为
 */
extension Array where Element: Publisher {
  var zipAll: AnyPublisher<[Element.Output], Element.Failure> {
    let initial = Just([Element.Output]())
      .setFailureType(to: Element.Failure.self)
      .eraseToAnyPublisher()
    return reduce(initial) { result, publisher in
      result
        .zip(publisher) {
          $0 + [$1]
        }
        .eraseToAnyPublisher()
    }
  }
}
