//: [Previous](@previous)

import Foundation
import Combine
import SwiftUI

var greeting = "Publisher 引用共享"

class LoadingUI {
    var isSuccess: Bool = false {
        didSet {
            print("isSuccess: \(isSuccess)")
        }
    }
    var text: String = "" {
        didSet {
            print("text: \(text)")
        }
    }
}

struct Response: Decodable {
    struct Foo: Decodable {
        let foo: String
    }
    let args: Foo?
}
let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: URL(string: "https://httpbin.org/get?foo=bar")!)
    .share()

let isSuccess = dataTaskPublisher.map { data, response -> Bool in
    guard let httpRes = response as? HTTPURLResponse else {
        return false
    }
    return httpRes.statusCode == 200
}
    .replaceError(with: false)

let latestText = dataTaskPublisher
    .map { data, _ in data }
    .decode(type: Response.self, decoder: JSONDecoder())
    .compactMap { $0.args?.foo }
    .replaceError(with: "")

let ui = LoadingUI()
var token1 = isSuccess.assign(to: \.isSuccess, on: ui)
var token2 = latestText.assign(to: \.text, on: ui)
