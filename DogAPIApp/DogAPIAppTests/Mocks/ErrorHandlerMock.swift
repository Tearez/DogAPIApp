//
//  ErrorHandlerMock.swift
//  DogAPIAppTests
//
//  Created by Martin Dimitrov on 3.05.23.
//

import Foundation
@testable import DogAPIApp

final class ErrorHandlerMock: ErrorHandlerProtocol {
    
    var handleErrorHandler: ((String, (() -> Void)?, (() async -> Void)?) -> Void)?
    private(set) var handleCallCount: Int = 0
    func handle(_ errorMessage: String, dismissHandler: (() -> Void)?, retryHandler: (() async -> Void)?) {
        handleCallCount += 1
        handleErrorHandler?(errorMessage, dismissHandler, retryHandler)
    }
}
