//
//  DogsRepositories.swift
//  DogAPIApp
//
//  Created by Martin Dimitrov on 2.05.23.
//

import Foundation
import DogAPIPackage

protocol DogsRepositoryProtocol {
    func getRandomDogImageUrl() async -> Result<URL>
    func getRandomDogsImageUrls(_ count: Int) async -> Result<[URL]>
    func getNextDogImageUrl() async -> Result<URL>
    func getPreviousDogImageUrl() -> Result<URL?>
}

final class DogsRepository: DogsRepositoryProtocol {
    private let library = DogsLibrary()
    
    func getRandomDogImageUrl() async -> Result<URL> {
        do {
            let image = try await library.getImage()
            guard let url = URL(string: image.url) else {
                return .failure(DogsError(error: "Invalid URL"))
            }
            return .success(url)
        } catch let error {
            return .failure(DogsError(error: error.localizedDescription))
        }
    }
    
    func getRandomDogsImageUrls(_ count: Int) async -> Result<[URL]> {
        do {
            let images = try await library.getImages(count)
            let imageUrls = images.compactMap { URL(string: $0.url) }
            guard !imageUrls.isEmpty else {
                return .failure(DogsError(error: "Invalid URLs"))
            }
            return .success(imageUrls)
        } catch let error {
            return .failure(DogsError(error: error.localizedDescription))
        }
    }
    
    func getNextDogImageUrl() async -> Result<URL> {
        do {
            let image = try await library.getNextImage()
            guard let url = URL(string: image.url) else {
                return .failure(DogsError(error: "Invalid URL"))
            }
            return .success(url)
        } catch let error {
            return .failure(DogsError(error: error.localizedDescription))
        }
    }
    
    func getPreviousDogImageUrl() -> Result<URL?> {
        let image = library.getPreviousImage()
        let urlString = image?.url
        guard let imageURL = urlString else {
            return .success(nil)
        }
        guard let url = URL(string: imageURL) else {
            return .failure(DogsError(error: "Invalid URL"))
        }
        return .success(url)
    }
}
