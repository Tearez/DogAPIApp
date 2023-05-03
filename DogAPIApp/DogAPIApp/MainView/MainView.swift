//
//  MainView.swift
//  DogAPIApp
//
//  Created by Martin Dimitrov on 2.05.23.
//

import SwiftUI
import Kingfisher

struct MainView: View {
    @StateObject private var viewModel: MainViewModel = .init(repository: DogsRepository())
    
    var body: some View {
        Group {
            switch viewModel.presentedImage {
            case .loading:
                loader
            case .loaded(let url, let previousButtonEnabled):
                fullView(imageUrl: url,
                         previousButtonEnabled: previousButtonEnabled)
            }
        }
        .task {
            await viewModel.initialLoad()
        }
    }
    
    private var loader: some View {
        ProgressView()
    }
    
    private func fullView(imageUrl: URL, previousButtonEnabled: Bool) -> some View {
        VStack(spacing: 20) {
            KFImage(imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .padding(.top, 15)
                .padding(.horizontal, 30)
                
            Spacer()
            
            HStack {
                Button("Previous", action: {
                    Task(priority: .userInitiated) {
                        await viewModel.getPreviousImage()
                    }
                })
                .foregroundColor(.white)
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(!previousButtonEnabled)
                
                Button("Next", action: {
                    Task(priority: .userInitiated) {
                        await viewModel.getNextImage()
                    }
                })
                .foregroundColor(.white)
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                
            }
            .padding(.bottom, 10)
        }
        .background(Color(.white))
        .cornerRadius(20)
        .shadow(radius: 1)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
