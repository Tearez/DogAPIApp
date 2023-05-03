//
//  Result.swift
//  DogAPIApp
//
//  Created by Martin Dimitrov on 2.05.23.
//

import Foundation

struct DogsError: Error {
    let error: String
}

enum Result<T> {
    case failure(DogsError)
    case success(T)
}
