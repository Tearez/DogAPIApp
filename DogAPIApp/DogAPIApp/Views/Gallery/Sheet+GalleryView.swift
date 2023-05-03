//
//  Sheet+GalleryView.swift
//  DogAPIApp
//
//  Created by Martin Dimitrov on 3.05.23.
//

import SwiftUI

struct GallerySheetModifier: ViewModifier {
    private let models: [GalleryModel]
    
    init(models: [GalleryModel]) {
        self.models = models
    }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: .constant(!models.isEmpty)) {
                GalleryView(models: models)
            }
    }
}

extension View {
    func gallerySheet(models: [GalleryModel]) -> some View {
        self
            .modifier(GallerySheetModifier(models: models))
    }
}
