//
//  Models+Mocks.swift
//  DogAPIAppTests
//
//  Created by Martin Dimitrov on 3.05.23.
//

import Foundation
@testable import DogAPIApp

extension DogsError {
    static let mock = Self.init(error: "test")
}

extension URL {
    static let mock1 = URL(string: "https://www.example.com/test")!
}

extension Array where Element == URL {
    static let mock = [ URL(string: "https://www.example.com/test1")!,
                        URL(string: "https://www.example.com/test2")!,
                        URL(string: "https://www.example.com/test3")!]
}
