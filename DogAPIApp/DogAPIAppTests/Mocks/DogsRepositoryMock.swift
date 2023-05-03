//
//  DogsRepositoryMock.swift
//  DogAPIAppTests
//
//  Created by Martin Dimitrov on 3.05.23.
//

import Foundation
@testable import DogAPIApp

final class DogsRepositoryMock: DogsRepositoryProtocol {
    
    var getRandomDogImageUrlHandler: (() -> Result<URL>) = { .failure(.mock) }
    private(set) var getRandomDogImageUrlCallCount: Int = 0
    func getRandomDogImageUrl() async -> Result<URL> {
        getRandomDogImageUrlCallCount += 1
        return getRandomDogImageUrlHandler()
    }
    
    var getRandomDogsImageUrlsHandler: ((Int) -> Result<[URL]>) = { _ in .failure(.mock) }
    private(set) var getRandomDogsImageUrlsCallCount: Int = 0
    func getRandomDogsImageUrls(_ count: Int) async -> Result<[URL]> {
        getRandomDogsImageUrlsCallCount += 1
        return getRandomDogsImageUrlsHandler(count)
    }
    
    var getNextDogImageUrlHandler: (() -> Result<URL>) = { .failure(.mock) }
    private(set) var getNextDogImageUrlCallCount: Int = 0
    func getNextDogImageUrl() async -> Result<URL> {
        getNextDogImageUrlCallCount += 1
        return getNextDogImageUrlHandler()
    }
    
    var getPreviousDogImageUrlHandler: (() -> Result<URL?>) = { .failure(.mock) }
    private(set) var getPreviousDogImageUrlCallCount: Int = 0
    func getPreviousDogImageUrl() -> Result<URL?> {
        getPreviousDogImageUrlCallCount += 1
        return getPreviousDogImageUrlHandler()
    }
}
