//: [Previous](@previous)

import Foundation
import Combine

class Wrapper {
    @Published var text: String = "hoho"
}

var wrapper = Wrapper()
wrapper.$text
    .print()
    .sink { _ in
    } receiveValue: { _ in
    }

wrapper.text = "123"
wrapper.text = "abc"

/*
 receive subscription: (PublishedSubject)
 request unlimited
 receive value: (hoho)
 receive value: (123)
 receive value: (abc)
 receive cancel
 */

[1,2,3].publisher
    .sink { complete in
    switch complete {
    case .failure(let error):
        print("receive error: \(error)")
    case .finished:
        print("receive finished")
    }
} receiveValue: { value in
    print("receive value: \(value)")
}

/*
 receive value: 1
 receive finished
 */
