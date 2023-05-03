//
//  GalleryView.swift
//  DogAPIApp
//
//  Created by Martin Dimitrov on 3.05.23.
//

import SwiftUI
import Kingfisher

struct GalleryView: View {
    @StateObject private var viewModel: GalleryViewModel
    
    init(models: [GalleryModel]) {
        self._viewModel = StateObject(wrappedValue: .init(models: models))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [.init(.flexible())]) {
                ForEach(viewModel.models) { model in
                    KFImage(model.url)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, 15)
                        .padding(.horizontal, 30)
                }
            }
            .padding(.vertical, 20)
        }
    }
}

//struct GalleryView_Previews: PreviewProvider {
//    static var previews: some View {
//        GalleryView(viewModel: .init(url: ))
//    }
//}
