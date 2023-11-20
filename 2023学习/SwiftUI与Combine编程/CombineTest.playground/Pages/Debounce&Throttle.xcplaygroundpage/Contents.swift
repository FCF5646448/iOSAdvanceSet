//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Hello, playground"

print("Debounce")
let searchText = PassthroughSubject<String, Never>()
let temp = searchText.debounce(for: .seconds(1), scheduler: RunLoop.main)
delay(0) { searchText.send("S") }
delay(0.1) { searchText.send("Sw") }
delay(0.2) { searchText.send("Swi") }
delay(1.3) { searchText.send("Swif") }
delay(1.4) { searchText.send("Swift") }

print("Throttle")
let searchText2 = PassthroughSubject<String, Never>()
let temp2 = searchText2.throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
delay(0) { searchText2.send("S") }
delay(0.1) { searchText2.send("Sw") }
delay(0.2) { searchText2.send("Swi") }
delay(1.3) { searchText2.send("Swif") }
delay(1.4) { searchText2.send("Swift") }
