//
//  ErrorHandler.swift
//  DogAPIApp
//
//  Created by Martin Dimitrov on 3.05.23.
//

import Foundation
import UIKit

typealias ErrorHandlerActionHandler = () -> Void
typealias ErrorHandlerActionAsyncHandler = () async -> Void
enum ErrorHandlerAction {
    case dismiss(ErrorHandlerActionHandler?)
    case retry(ErrorHandlerActionAsyncHandler)
}

protocol ErrorHandlerProtocol {
    func handle(_ errorMessage: String, dismissHandler: (() -> Void)?, retryHandler: (() async -> Void)?)
}

final class ErrorHandler: ErrorHandlerProtocol {
    func handle(_ errorMessage: String, dismissHandler: (() -> Void)?, retryHandler: (() async -> Void)?) {
        DispatchQueue.main.async {
            
            guard let topController = UIApplication.shared.keyWindow?.rootViewController else {
                return
            }
            
            let alert = UIAlertController(title: "ERROR",
                                          message: errorMessage,
                                          preferredStyle: .alert)
            
            alert.addAction(.init(title: "Dismiss", style: .cancel, handler: { _ in dismissHandler?() }))
            if let retryHandler = retryHandler {
                alert.addAction(.init(title: "Retry", style: .default, handler: { _ in
                    Task {
                        await retryHandler()
                    }
                }))
            }
            
            topController.present(alert, animated: true)
        }
    }
}
