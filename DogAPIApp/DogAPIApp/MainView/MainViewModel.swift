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
    
    @MainActor @Published private(set) var presentedImage: MainViewState = .loading
    
    init(repository: DogsRepositoryProtocol) {
        self.repository = repository
    }
    
    func initialLoad() async {
        await MainActor.run {
            self.presentedImage = .loading
        }
        
        let result = await repository.getNextDogImageUrl()
        
        switch result {
        case .failure(let dogsError):
            break
        case .success(let url):
            await MainActor.run {
                self.presentedImage = .loaded(url, false)
            }
        }
    }
    
    func getNextImage() async {
        await MainActor.run {
            self.presentedImage = .loading
        }
        
        let result = await repository.getNextDogImageUrl()
        
        switch result {
        case .failure(let dogsError):
            break
        case .success(let url):
            await MainActor.run {
                self.presentedImage = .loaded(url, true)
            }
        }
    }
    
    func getPreviousImage() async {
        let result = repository.getPreviousDogImageUrl()
        
        switch result {
        case .failure(let dogsError):
            break
        case .success(let url):
            guard let url = url else { return }
            await MainActor.run {
                self.presentedImage = .loaded(url, true)
            }
        }
    }
}
