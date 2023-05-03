//
//  MainViewModelTests.swift
//  DogAPIAppTests
//
//  Created by Martin Dimitrov on 3.05.23.
//

import CombineTestExtensions
import XCTest
@testable import DogAPIApp

final class MainViewModelTests: XCTestCase {
    private var errorHandler: ErrorHandlerMock!
    private var dogsRepository: DogsRepositoryMock!
    private var viewModel: MainViewModel!
    
    override func setUp() {
        super.setUp()
        
        errorHandler = ErrorHandlerMock()
        dogsRepository = DogsRepositoryMock()
        viewModel = MainViewModel(repository: dogsRepository,
                                  errorHandler: errorHandler)
    }
    
    func testInitialState() async {
        let state = await viewModel.state
        let sheetData = await viewModel.sheetData
        let input = viewModel.input
        XCTAssertEqual(state, .loading)
        XCTAssertEqual(sheetData, [])
        XCTAssertEqual(input, "")
    }
    
    func testInitialLoad() async {
        let recorder = viewModel.$state.dropFirst().record(numberOfRecords: 2)
        
        dogsRepository.getNextDogImageUrlHandler = { .success(.mock1) }
        await viewModel.initialLoad()
        
        let records = recorder.waitAndCollectRecords()
        XCTAssertEqual(records, [.value(.loading), .value(.loaded(.mock1, false))])
        validateCalled(getNextDogImageUrl: 1)
    }
    
    func testGetNextImageSuccess() async {
        let recorder = viewModel.$state.dropFirst().record(numberOfRecords: 1)
        
        dogsRepository.getNextDogImageUrlHandler = { .success(.mock1) }
        await viewModel.getNextImage()
        
        let records = recorder.waitAndCollectRecords()
        XCTAssertEqual(records, [.value(.loaded(.mock1, true))])
        validateCalled(getNextDogImageUrl: 1)
    }
    
    func testGetNextImageFail() async {
        dogsRepository.getNextDogImageUrlHandler = { .failure(.mock) }
        errorHandler.handleErrorHandler = { errorMessage, dismissHandler, retryHandler in
            XCTAssertEqual(errorMessage, "test")
            XCTAssertNil(dismissHandler)
            XCTAssertNil(retryHandler)
        }
        await viewModel.getNextImage()
        validateCalled(getNextDogImageUrl: 1,
                       handleError: 1)
    }
    
    func testGetPreviousImageSuccess() async {
        let recorder = viewModel.$state.dropFirst().record(numberOfRecords: 1)
        
        dogsRepository.getPreviousDogImageUrlHandler = { .success(.mock1) }
        await viewModel.getPreviousImage()
        
        let records = recorder.waitAndCollectRecords()
        XCTAssertEqual(records, [.value(.loaded(.mock1, true))])
        validateCalled(getPreviousDogImageUrl: 1)
    }
    
    func testGetPreviousImageFail() async {
        errorHandler.handleErrorHandler = { errorMessage, dismissHandler, retryHandler in
            XCTAssertEqual(errorMessage, "test")
            XCTAssertNil(dismissHandler)
            XCTAssertNil(retryHandler)
        }
        dogsRepository.getPreviousDogImageUrlHandler = { .failure(.mock) }
        await viewModel.getPreviousImage()
        
        validateCalled(getPreviousDogImageUrl: 1,
                       handleError: 1)
    }
    
    func testSubmitInputEmpty() async {
        errorHandler.handleErrorHandler = { errorMessage, dismissHandler, retryHandler in
            XCTAssertEqual(errorMessage, "Input must a number between 1 & 10")
            XCTAssertNil(dismissHandler)
            XCTAssertNil(retryHandler)
        }
        
        await viewModel.submitInput()
        validateCalled(handleError: 1)
    }
    
    func testSubmitInputInvalid() async {
        errorHandler.handleErrorHandler = { errorMessage, dismissHandler, retryHandler in
            XCTAssertEqual(errorMessage, "Input must a number between 1 & 10")
            XCTAssertNil(dismissHandler)
            XCTAssertNil(retryHandler)
        }
        viewModel.input = "100"
        await viewModel.submitInput()
        validateCalled(handleError: 1)
        
        viewModel.input = "-100"
        await viewModel.submitInput()
        validateCalled(handleError: 2)
        
        viewModel.input = "asf"
        await viewModel.submitInput()
        validateCalled(handleError: 3)
    }
    
    func testSubmitInputOne() async {
        let recorder = viewModel.$sheetData.dropFirst().record(numberOfRecords: 1)
        dogsRepository.getRandomDogImageUrlHandler = { .success(.mock1) }
        
        viewModel.input = "1"
        await viewModel.submitInput()
        let records = recorder.waitAndCollectRecords()
        XCTAssertEqual(records, [.value([.init(url: .mock1)])])
        validateCalled(getRandomDogImageUrl: 1)
    }
    
    func testSubmitInputMoreThanOne() async {
        let expectedResults: [GalleryModel] = Array<URL>.mock.map { .init(url: $0) }
        let recorder = viewModel.$sheetData.dropFirst().record(numberOfRecords: 1)
        dogsRepository.getRandomDogsImageUrlsHandler = { imagesCount in
            XCTAssertEqual(imagesCount, 8)
            return .success(.mock)
        }
        
        viewModel.input = "8"
        await viewModel.submitInput()
        let records = recorder.waitAndCollectRecords()
        
        XCTAssertEqual(records, [.value(expectedResults)])
        validateCalled(getRandomDogsImageUrls: 1)
    }
    
    func testSubmitInputOneFailed() async {
        errorHandler.handleErrorHandler = { errorMessage, dismissHandler, retryHandler in
            XCTAssertEqual(errorMessage, "test")
            XCTAssertNil(dismissHandler)
            XCTAssertNil(retryHandler)
        }
        dogsRepository.getRandomDogImageUrlHandler = { .failure(.mock) }
        
        viewModel.input = "1"
        await viewModel.submitInput()
        validateCalled(getRandomDogImageUrl: 1,
                       handleError: 1)
    }
    
    func testSubmitInputMoreThanOneFailed() async {
        errorHandler.handleErrorHandler = { errorMessage, dismissHandler, retryHandler in
            XCTAssertEqual(errorMessage, "test")
            XCTAssertNil(dismissHandler)
            XCTAssertNil(retryHandler)
        }
        dogsRepository.getRandomDogImageUrlHandler = { .failure(.mock) }
        
        viewModel.input = "8"
        await viewModel.submitInput()
        validateCalled(getRandomDogsImageUrls: 1,
                       handleError: 1)
    }
    
    private func validateCalled(getRandomDogImageUrl: Int = 0,
                                getRandomDogsImageUrls: Int = 0,
                                getNextDogImageUrl: Int = 0,
                                getPreviousDogImageUrl: Int = 0,
                                handleError: Int = 0) {
        XCTAssertEqual(getRandomDogImageUrl, dogsRepository.getRandomDogImageUrlCallCount)
        XCTAssertEqual(getRandomDogsImageUrls, dogsRepository.getRandomDogsImageUrlsCallCount)
        XCTAssertEqual(getNextDogImageUrl, dogsRepository.getNextDogImageUrlCallCount)
        XCTAssertEqual(getPreviousDogImageUrl, dogsRepository.getPreviousDogImageUrlCallCount)
        XCTAssertEqual(handleError, errorHandler.handleCallCount)
    }
}

extension MainViewState: Equatable {
    public static func == (lhs: MainViewState, rhs: MainViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loaded),
            (.loaded, .loading):
            return false
        case (.loading, .loading):
            return true
        case (.loaded(let lhsUrl, let lhsIsEnabled), .loaded(let rhsUrl, let rhsIsEnabled)):
            return lhsUrl.absoluteString == rhsUrl.absoluteString &&
            lhsIsEnabled == rhsIsEnabled
        }
    }
}

extension GalleryModel: Equatable {
    public static func == (lhs: GalleryModel, rhs: GalleryModel) -> Bool {
        lhs.url.absoluteString == rhs.url.absoluteString
    }
}
