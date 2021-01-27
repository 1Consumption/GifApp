//
//  GifCellViewModelTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import XCTest

final class GifCellViewModelTests: XCTestCase {
 
    private let input: GifCellViewModelInput = GifCellViewModelInput()
    private let gifInfo: GifInfo = GifInfo(id: "1",
                                           username: "",
                                           source: "",
                                           images: GifImages(original: GifImage(height: "", width: "", url: ""),
                                                             fixedWidth: GifImage(height: "", width: "", url: "test")),
                                           user: User(avatarUrl: "", username: "", displayName: ""))
    private var bag: CancellableBag = CancellableBag()
    private var viewModel: GifCellViewModel!
    
    func testViewModelOutputGifDelivered() {
        let expectation = XCTestExpectation(description: "gif delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockSuccessGifCellUseCase()
        viewModel = GifCellViewModel(gifInfo: gifInfo, gifCellUseCase: useCase)
        
        let output = viewModel.transform(input).gifDelivered
        
        output.bind { _ in
            useCase.verifyRetrieveImage(url: "test")
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGif.fire()
    }
    
    func testViewModelCancellable() {
        let expectation = XCTestExpectation(description: "cancelled")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockSuccessGifCellUseCase(handler: { expectation.fulfill() })
        viewModel = GifCellViewModel(gifInfo: gifInfo, gifCellUseCase: useCase)
        
        let _ = viewModel?.transform(input)
        
        input.loadGif.fire()
        
        viewModel = nil
    }
    
    func testViewModelOutputErrorDelivered() {
        let expectation = XCTestExpectation(description: "error delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockFailureGifCellUseCase(retrieveImageError: .emptyData)
        viewModel = GifCellViewModel(gifInfo: gifInfo, gifCellUseCase: useCase)
        
        let output = viewModel.transform(input).errorDelivered
        
        output.bind {
            useCase.verifyRetrieveImage(url: "test")
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGif.fire()
    }
    
    func testViewModelOutputFavoriteDelivered() {
        let expectation = XCTestExpectation(description: "favorite state is favorite delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockSuccessGifCellUseCase()
        viewModel = GifCellViewModel(gifInfo: gifInfo, gifCellUseCase: useCase)
        
        let output = viewModel.transform(input).favoriteConfirm
        
        output.bind {
            useCase.verifysendFavoriteStateChange(gifInfo: self.gifInfo)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.favoriteStateShouldChange.fire()
    }
    
    func testViewModelOutputFavoriteCancelDelivered() {
        let expectation = XCTestExpectation(description: "favorite state is favorite cancel delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockSuccessGifCellUseCase(isFavorite: true)
        viewModel = GifCellViewModel(gifInfo: gifInfo, gifCellUseCase: useCase)
        
        let output = viewModel.transform(input).favoriteCanceled
        
        output.bind {
            useCase.verifysendFavoriteStateChange(gifInfo: self.gifInfo)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.favoriteStateShouldChange.fire()
    }
    
    func testViewModelOutputFavoriteManagerErrorDelivered() {
        let expectation = XCTestExpectation(description: "favorite error delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockFailureGifCellUseCase(sendFavoriteStateChangeError: .encodeError)
        viewModel = GifCellViewModel(gifInfo: gifInfo, gifCellUseCase: useCase)
        
        let output = viewModel.transform(input).favoriteErrorDelivered
        
        output.bind {
            XCTAssertEqual($0, .encodeError)
            useCase.verifysendFavoriteStateChange(gifInfo: self.gifInfo)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.favoriteStateShouldChange.fire()
    }
}
