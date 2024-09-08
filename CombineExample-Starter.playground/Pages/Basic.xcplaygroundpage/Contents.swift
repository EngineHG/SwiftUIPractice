import Combine

check("Empty") {
    Empty<Int, SampleError>()
}

check("Just") {
    Just("Hello SwiftUI")
}

check("Sequence") {
  Publishers.Sequence<[Int], Never>(sequence: [1, 2, 3])
}

check("Array") {
  [1, 2, 3].publisher
}

check("Map") {
  [1, 2, 3]
    .publisher
    .map { $0 * 2 }
}

check("Map Just") {
  Just(5).map { $0 * 2 }
}

check("Reduce") {
  [1, 2, 3, 4, 5].publisher.reduce(0, +)
}

check("Scan") {
  [1, 2, 3, 4, 5].publisher.scan(0, +)
}

check("Compact Map") {
  ["1", "2", "3", "cat", "5"]
    .publisher
    .compactMap { Int($0) }
}

check("Compact Map By Filter") {
  ["1", "2", "3", "cat", "5"]
    .publisher
    .map { Int($0) }
    .filter { $0 != nil }
    .map { $0! }
}

check("Flat Map 1") {
  [[1, 2, 3], ["a", "b", "c"]]
    .publisher
    .flatMap {
      $0.publisher
    }
}

check("Flat Map 2") {
  ["A", "B", "C"]
    .publisher
    .flatMap { letter in
      [1, 2, 3]
        .publisher
        .map { letter + String($0) }
    }
}

check("Remove Duplicates") {
  ["S", "Sw", "Sw", "Sw", "Swi","Swif", "Swift", "Swift", "Swif"]
    .publisher
    .removeDuplicates()
}

check("Fail") {
  Fail<Int, SampleError>(error: .sampleError)
}

enum MyError: Error {
  case myError
}

check("Map Error") {
  Fail<Int, SampleError>(error: .sampleError)
    .mapError { _ in
      MyError.myError
    }
}

check("Throw") {
  ["1", "2", "Swift", "4"]
    .publisher
    .tryMap { s -> Int in
      guard let value = Int(s) else { throw MyError.myError }
      return value
    }
}

check("Replace Error") {
  ["1", "2", "Swift", "4"]
    .publisher
    .tryMap { s -> Int in
      guard let value = Int(s) else { throw MyError.myError }
      return value
    }
    .replaceError(with: -1)
}

check("Catch with Just") {
  ["1", "2", "Swift", "4"]
    .publisher
    .tryMap { s -> Int in
      guard let value = Int(s) else { throw MyError.myError }
      return value
    }
    .catch { _ in
      Just(-1)
    }
}

check("Catch with Another Publisher") {
  ["1", "2", "Swift", "4"]
    .publisher
    .tryMap { s -> Int in
      guard let value = Int(s) else { throw MyError.myError }
      return value
    }
    .catch { _ in
      [-1, -2, -3].publisher
    }
}

check("Catch and Continue") {
  ["1", "2", "Swift", "4"]
    .publisher
    //.print("[Original]")
    .flatMap { s in
      return Just(s)
        .tryMap { s -> Int in
          guard let value = Int(s) else { throw MyError.myError }
          return value
        }
        //.print("[TryMap]")
        .catch { _ in
          Just(-1)
            //.print("Just")
        }
        //.print("[Catch]")
    }
}

check("Filter") {
  [1, 2, 3, 4, 5]
    .publisher
    .filter { $0 % 2 == 0 }
}

check("Contains") {
  [1, 2, 3, 4, 5]
    .publisher
    .print()
    .contains(10)
}

check("Prefix") {
  [1, 2, 3, 4, 5]
    .publisher
    .prefix(2)
}

check("Drop") {
  [1, 2, 3, 4, 5]
    .publisher
    .drop{ $0 < 4 }
}

check("ReplaceNil") {
  [1, 2, 3, 4, 5, nil, 7]
    .publisher
    .replaceNil(with: 6)
}

check("ReplaceEmpty") {
  []
    .publisher
    .replaceEmpty(with: "EmptyPlaceHolder")
}

check("Min") {
  //[3, 1, 2]
  ["b", "B", "a"]
    .publisher
    .min()
}

check("Max") {
  //[3, 1, 2]
  ["b", "B", "a"]
    .publisher
    .max()
}

check("AllSatisfy") {
  [1, 2, 3, 4, 5]
    .publisher
    .allSatisfy {
      return $0 > 1 //信号是否全部满足条件
    }
}

check("Collect") {
  //[1, 2, 3, 4, 5]
  [[1, 2], [3, 4], 5]
  .publisher
  //Just(1)
    .collect()
}


//check("Merge") {
//  [1: "A", 3: "C", 5: "E"]
//    .timerPublisher
//    .merge(with: [1: "B", 4: "D", 6: "F"].timerPublisher)
//}


//MARK: - 4. 深入理解 flatMap
//let outer: PassthroughSubject<String, Never> = PassthroughSubject()
//let inner: PassthroughSubject<String, Never> = PassthroughSubject()
//
//check("深入理解 flatMap") {
//  outer.flatMap { l in
//    inner.map {
//      l + $0
//    }
//  }
//}

//1.
//outer.send("A")
//inner.send("1")
//outer.send("B")
//inner.send("2")
//inner.send("3")
//outer.send("C")
//outer.send(completion: .finished)


//2.
//inner.send("1")
//outer.send("A")
//inner.send("2")
//outer.send("B")
//inner.send("3")
//inner.send(completion: .finished)
//outer.send("C")

