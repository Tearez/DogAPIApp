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
    @MainActor @Published var sheetData: [GalleryModel] = []
    @Published var input: String = ""
    
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
    
    func submitInput() async {
        guard let intInput = Int(input) else {
            return
        }
        
        switch intInput {
        case _ where intInput == 1:
            let result = await repository.getRandomDogImageUrl()
            
            switch result {
            case .failure(let dogsError):
                break
            case .success(let url):
                await MainActor.run {
                    self.sheetData = [url].map { GalleryModel(url: $0) }
                }
            }
        case _ where intInput > 1 && intInput <= 10:
            let result = await repository.getRandomDogsImageUrls(intInput)
            
            switch result {
            case .failure(let dogsError):
                break
            case .success(let urls):
                await MainActor.run {
                    self.sheetData = urls.map { GalleryModel(url: $0) }
                }
            }
        default:
            break
        }
    }
}
