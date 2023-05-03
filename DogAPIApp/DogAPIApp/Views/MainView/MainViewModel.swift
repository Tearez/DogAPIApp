//
//  MainViewModel.swift
//  DogAPIApp
//
//  Created by Martin Dimitrov on 2.05.23.
//

import Foundation

enum MainViewState {
    case loading
    case loaded(URL, Bool)
}

final class MainViewModel: ObservableObject {
    private let repository: DogsRepositoryProtocol
    private let errorHandler: ErrorHandlerProtocol
    
    @MainActor @Published private(set) var state: MainViewState = .loading
    @MainActor @Published var sheetData: [GalleryModel] = []
    @Published var input: String = ""
    
    init(repository: DogsRepositoryProtocol,
         errorHandler: ErrorHandlerProtocol) {
        self.repository = repository
        self.errorHandler = errorHandler
    }
    
    func initialLoad() async {
        await MainActor.run {
            self.state = .loading
        }
        
        let result = await repository.getNextDogImageUrl()
        
        await handle(result) { item in
            await MainActor.run {
                self.state = .loaded(item, false)
            }
        } retryAction: { [weak self] in
            await self?.initialLoad()
        }
    }
    
    func getNextImage() async {
        let result = await repository.getNextDogImageUrl()
        
        await handle(result) { item in
            await MainActor.run {
                self.state = .loaded(item, true)
            }
        }
    }
    
    func getPreviousImage() async {
        let result = repository.getPreviousDogImageUrl()
        
        await handle(result) { item in
            await MainActor.run {
                guard let url = item else { return }
                self.state = .loaded(url, true)
            }
        }
    }
    
    func submitInput() async {
        guard let intInput = Int(input) else {
            errorHandler.handle("Input must a number between 1 & 10", dismissHandler: nil, retryHandler: nil)
            return
        }
        
        switch intInput {
        case _ where intInput == 1:
            let result = await repository.getRandomDogImageUrl()
            
            await handle(result) { item in
                await MainActor.run {
                    self.sheetData = [item].map { GalleryModel(url: $0) }
                }
            }
        case _ where intInput > 1 && intInput <= 10:
            let result = await repository.getRandomDogsImageUrls(intInput)
            await handle(result) { items in
                await MainActor.run {
                    self.sheetData = items.map { GalleryModel(url: $0) }
                }
            }
        default:
            errorHandler.handle("Input must a number between 1 & 10", dismissHandler: nil, retryHandler: nil)
        }
    }
}

// MARK: - Private
private extension MainViewModel {
    func handle<T>(_ result: Result<T>, success: @escaping (T) async -> Void, retryAction: (() async -> Void)? = nil) async {
        switch result {
        case .failure(let dogsError):
            errorHandler.handle(dogsError.error, dismissHandler: nil, retryHandler: retryAction)
        case .success(let item):
            await success(item)
        }
    }
}
