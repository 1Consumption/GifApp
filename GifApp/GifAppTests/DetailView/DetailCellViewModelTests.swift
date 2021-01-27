//
//  DetailCellViewModelTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/27.
//

@testable import GifApp
import XCTest

final class DetailCellViewModelTests: XCTestCase {
    
    private var viewModel: DetailCellViewModel!
    private var bag: CancellableBag = CancellableBag()
    private let gifInfo: GifInfo = GifInfo(id: "1",
                                           username: "",
                                           source: "",
                                           images: GifImages(original: GifImage(height: "", width: "", url: ""),
                                                             fixedWidth: GifImage(height: "", width: "", url: "test")),
                                           user: User(avatarUrl: "", username: "", displayName: ""))
    private let input: DetailCellViewModelInput = DetailCellViewModelInput()
    
    func testOutputGifDelivered() {
        let expectation = XCTestExpectation(description: "retrieve gif image")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockSuccessDetailUseCase()
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).gifDelivered
        
        output.bind {
            XCTAssertNotNil($0)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGif.fire()
    }
    
    func testOutputIsFavoriteDelivered() {
        let expectation = XCTestExpectation(description: "isFavorite delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let isFavorite = false
        let useCase = MockSuccessDetailUseCase(isFavorite: isFavorite)
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).isFavoriteDelivered
        
        output.bind {
            XCTAssertEqual(isFavorite, $0)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.isFavorite.fire()
    }
    
    func testOutputFavoriteConfirm() {
        let expectation = XCTestExpectation(description: "favorite confirm")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let isFavorite = false
        let useCase = MockSuccessDetailUseCase(isFavorite: isFavorite)
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).favoriteConfirm
        
        output.bind {
            expectation.fulfill()
        }.store(in: &bag)
        
        input.favoriteStateShouldChange.fire()
    }
    
    func testOutputFavoriteCanceled() {
        let expectation = XCTestExpectation(description: "favorite canceled")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let isFavorite = true
        let useCase = MockSuccessDetailUseCase(isFavorite: isFavorite)
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).favoriteConfirm
        
        output.bind {
            expectation.fulfill()
        }.store(in: &bag)
        
        input.favoriteStateShouldChange.fire()
    }
    
    func testOutputImageErrorDeilivered() {
        let expectation = XCTestExpectation(description: "retrieve gif image error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockFailureDetailUseCase(retrieveImageError: .emptyData)
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).imageErrorDelivered
        
        output.bind {
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGif.fire()
    }
    
    func testOutputFavoriteErrorDelivered() {
        let expectation = XCTestExpectation(description: "favorite error delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockFailureDetailUseCase(sendFavoriteStateChangeError: .encodeError)
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).favoriteErrorDelivered
        
        output.bind {
            XCTAssertEqual($0, .encodeError)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.favoriteStateShouldChange.fire()
    }
}
