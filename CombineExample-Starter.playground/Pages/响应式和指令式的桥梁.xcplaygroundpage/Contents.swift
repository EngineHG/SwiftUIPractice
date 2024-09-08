import Combine
import Foundation


//func loadPage(
//  url: URL,
//  handler: @escaping (Data?, URLResponse?, Error?) -> Void)
//{
//  URLSession.shared.dataTask(with: url) {
//    data, response, error in
//    handler(data, response, error)
//  }.resume()
//}
//let future = check("Future") {
//  Future<(Data, URLResponse), Error> { promise in
//    loadPage(url: URL(string: "https://example.com")!) { data, response, error in
//      if let data = data, let response = response {
//        promise(.success((data, response)))
//      } else if let error = error {
//        promise(.failure(error))
//      } else {
//        promise(.failure(URLError(.badURL)))
//      }
//    }
//  }
//}


//let subject = PassthroughSubject<Date, Never>()
//Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//  subject.send(Date())
//}
//let timer = check("Timer") {
//  subject
//}

//MARK: - Foundation 中的 Publisher
//struct Response: Decodable {
//  struct Args: Decodable {
//    let foo: String
//  }
//  let args: Args?
//}
//let subscription = check("URLSession") {
//  URLSession.shared
//    .dataTaskPublisher(for: URL(string: "https://httpbin.org/get?foo=bar")!)
//    .map { data, _ in data }
//    .decode(type: Response.self, decoder: JSONDecoder())
//    .compactMap { $0.args?.foo }
//}


//let timer = Timer.publish(every: 1, on: .main, in: .default)
//let tmp = check("Timer") {
//  timer
//}
//timer.connect()


//class Wrapper {
//    @Published var text: String = "hoho"
//}
//var wrapper = Wrapper()
//let t = check("Published") {
//    wrapper.$text
//}
//wrapper.text = "123"
//wrapper.text = "abcigj"
//
//
//class Clock {
//    var timeString: String = "--:--:--" {
//        willSet { print(newValue) }
//    }
//}
//let clock = Clock()
//let formatter = DateFormatter()
//formatter.timeStyle = .medium
//let timer = Timer.publish(every: 1, on: .main, in: .default)
//let token = timer
//    .map { formatter.string(from: $0) }
//    .assign(to: \.timeString, on: clock)
//timer.connect()
//delay(3) {
//    token.cancel()
//}


//class LoadingUI {
//    var isSuccess: Bool = false
//    var text: String = ""
//}
//struct Response: Decodable {
//    struct Foo: Decodable {
//        let foo: String
//    }
//    let args: Foo?
//}
//let dataTaskPublisher = URLSession.shared
//    .dataTaskPublisher(for: URL(string: "https://httpbin.org/get?foo=bar")!).share()
//let isSuccess = dataTaskPublisher
//    .map { data, response -> Bool in
//        guard let response = response as? HTTPURLResponse else { return false }
//        return response.statusCode == 200
//    }
//    .replaceError(with: false)
//let latestText = dataTaskPublisher
//    .map { data, _ in data}
//    .decode(type: Response.self, decoder: JSONDecoder())
//    .compactMap { $0.args?.foo }
//    .replaceError(with: "")
//let ui = LoadingUI()
//var token1 = isSuccess.assign(to: \.isSuccess, on: ui)
//var token2 = latestText.assign(to: \.text, on: ui)

//MARK: - 练习

//let searchText = PassthroughSubject<String, Never>()
//let t = check("Debounce") {
//    searchText
//        .scan("") {
//            [$0, $1]
//                .joined(separator: " ")
//                .trimmingCharacters(in: .whitespacesAndNewlines) }
//        .map { $0 }
//        .debounce(for: .seconds(1), scheduler: RunLoop.main)
//}
//delay(0.1) { searchText.send("I") }
//delay(0.2) { searchText.send("Love") }
//delay(0.5) { searchText.send("SwiftUI") }
//delay(1.6) { searchText.send("And") }
//delay(2.0) { searchText.send("Combine") }


let inputText = PassthroughSubject<String, Never>()
let t = check("Throttle") {
    inputText
        .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
//        .debounce(for: .seconds(1), scheduler: RunLoop.main)
}

delay(0) { inputText.send("S") }
delay(0.1) { inputText.send("Sw") }
delay(0.2) { inputText.send("Swi") }
delay(1.3) { inputText.send("Swif") }
delay(1.4) { inputText.send("Swift") }
