//
//  GaleryViewModel.swift
//  DogAPIApp
//
//  Created by Martin Dimitrov on 3.05.23.
//

import Foundation

struct GalleryModel: Identifiable {
    let id: String = UUID().uuidString
    let url: URL
}

final class GalleryViewModel: ObservableObject {
    var models: [GalleryModel]
    
    init(models: [GalleryModel]) {
        self.models = models
    }
}
