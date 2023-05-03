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
    @FocusState private var isFocused
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Group {
                    switch viewModel.presentedImage {
                    case .loading:
                        loader
                    case .loaded(let url, let previousButtonEnabled):
                        fullView(imageUrl: url,
                                 previousButtonEnabled: previousButtonEnabled)
                    }
                }
                Spacer()
                
                gallerySubmition
                
                Spacer()
            }
        }
        .gallerySheet(models: viewModel.sheetData)
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
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .padding(.top, 15)
                .padding(.horizontal, 30)
                            
            HStack {
                Button("Previous") {
                    Task(priority: .userInitiated) {
                        await viewModel.getPreviousImage()
                    }
                }
                .foregroundColor(.white)
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(!previousButtonEnabled)
                
                Button("Next") {
                    Task(priority: .userInitiated) {
                        await viewModel.getNextImage()
                    }
                }
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
    
    private var gallerySubmition: some View {
        VStack {
            TextField("Enter amount between 1-10", text: $viewModel.input)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button("Dismiss") {
                            isFocused = false
                        }
                    }
                }
                
            Button("Submit") {
                Task {
                    await viewModel.submitInput()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
