//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Foundation内的URLSession Publisher"

struct Response: Decodable {
    struct Foo: Decodable {
        let foo: String
    }
    let args: Foo?
}

let input = PassthroughSubject<String, Error>()
let s = input.flatMap { text in
    URLSession.shared
        .dataTaskPublisher(for: URL(string: "https://httpbin.org/get?foo=\(text)")!)
        .map { data, _ in data }
        .decode(type: Response.self, decoder: JSONDecoder())
        .compactMap { $0.args?.foo }
    }
    .print()
    .sink { _ in
        } receiveValue: { _ in
        }

input.send("hello")
input.send("world")
input.send(completion: .finished)

/*
 receive subscription: (FlatMap)
 request unlimited
 receive value: (world)
 receive value: (hello)
 receive finished
 */
