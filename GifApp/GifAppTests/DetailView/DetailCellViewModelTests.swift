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
                                           images: GifImages(original: GifImage(height: "", width: "", url: "test"),
                                                             fixedWidth: GifImage(height: "", width: "", url: "test")),
                                           user: User(avatarUrl: "testURL", username: "testUserName", displayName: "testDisplayName"))
    private let gifInfoWithUserInfoNil: GifInfo = GifInfo(id: "1",
                                           username: "",
                                           source: "test",
                                           images: GifImages(original: GifImage(height: "", width: "", url: "test"),
                                                             fixedWidth: GifImage(height: "", width: "", url: "test")),
                                           user: nil)
    private let input: DetailCellViewModelInput = DetailCellViewModelInput()
    
    func testOutputGifDelivered() {
        let expectation = XCTestExpectation(description: "retrieve gif image")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockSuccessDetailUseCase()
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).gifDelivered
        
        output.bind {
            XCTAssertNotNil($0)
            useCase.verifyRetrieveImage(url: self.gifInfo.images.original.url)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGif.fire()
    }
    
    func testOutputUserInfoDeliveredWithUserInfoNotNil() {
        let expectation = XCTestExpectation(description: "userInfo with not nil delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = DummyDetailUseCase()
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).userInfoDelivered
        
        output.bind {
            XCTAssertEqual($0, UserInfo(userName: "testUserName", displayName: "testDisplayName"))
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadUserInfo.fire()
    }
    
    func testOutputUserInfoDeliveredWithUserInfoNil() {
        let expectation = XCTestExpectation(description: "userInfo with nil delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockSuccessDetailUseCase()
        let viewModel = DetailCellViewModel(gifInfo: gifInfoWithUserInfoNil, detailUseCase: useCase)
        
        let output = viewModel.transform(input).userInfoDelivered
        
        output.bind {
            XCTAssertEqual($0, UserInfo(userName: "Source", displayName: "test"))
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadUserInfo.fire()
    }
    
    func testOutputUserImageDeliveredSuccess() {
        let expectation = XCTestExpectation(description: "userImage delivered success")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockSuccessDetailUseCase()
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).userImageDelivered
        
        output.bind {
            useCase.verifyRetrieveImage(url: self.gifInfo.user!.avatarUrl)
            XCTAssertNotNil($0)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadUserInfo.fire()
    }
    
    func testOutputUserImageDeliveredFailure() {
        let expectation = XCTestExpectation(description: "userImage delivered failure")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockFailureDetailUseCase(retrieveImageError: .emptyData)
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).imageErrorDelivered
        
        output.bind {
            useCase.verifyRetrieveImage(url: self.gifInfo.user!.avatarUrl)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadUserInfo.fire()
    }
    
    func testOutputIsFavoriteDelivered() {
        let expectation = XCTestExpectation(description: "isFavorite delivered favorite")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let isFavorite = true
        let useCase = MockSuccessDetailUseCase(isFavorite: isFavorite)
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).favoriteConfirm
        
        output.bind {
            useCase.verifyRetrieveIsFavorite(gifInfo: self.gifInfo)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.isFavorite.fire()
    }
    
    func testOutputIsFavoriteDeliveredWithNonFavorite() {
        let expectation = XCTestExpectation(description: "isFavorite delivered non favorite")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let isFavorite = false
        let useCase = MockSuccessDetailUseCase(isFavorite: isFavorite)
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).favoriteCanceled
        
        output.bind {
            useCase.verifyRetrieveIsFavorite(gifInfo: self.gifInfo)
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
            useCase.verifysendFavoriteStateChange(gifInfo: self.gifInfo)
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
        
        let output = viewModel.transform(input).favoriteCanceled
        
        output.bind {
            useCase.verifysendFavoriteStateChange(gifInfo: self.gifInfo)
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
            useCase.verifyRetrieveImage(url: self.gifInfo.images.original.url)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadGif.fire()
    }
    
    func testOutputFavoriteErrorDeliveredWithStateChangeMethod() {
        let expectation = XCTestExpectation(description: "favorite error delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockFailureDetailUseCase(sendFavoriteStateChangeError: .encodeError)
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).favoriteErrorDelivered
        
        output.bind {
            useCase.verifysendFavoriteStateChange(gifInfo: self.gifInfo)
            XCTAssertEqual($0, .encodeError)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.favoriteStateShouldChange.fire()
    }
    
    func testOutputFavoriteErrorDeliveredWithIsFavoriteMethod() {
        let expectation = XCTestExpectation(description: "favorite error delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let useCase = MockFailureDetailUseCase(retrieveIsFavoriteError: .diskStorageError(.canNotFoundDocumentDirectory))
        let viewModel = DetailCellViewModel(gifInfo: gifInfo, detailUseCase: useCase)
        
        let output = viewModel.transform(input).favoriteErrorDelivered
        
        output.bind {
            useCase.verifyRetrieveIsFavorite(gifInfo: self.gifInfo)
            XCTAssertEqual($0, .diskStorageError(.canNotFoundDocumentDirectory))
            expectation.fulfill()
        }.store(in: &bag)
        
        input.isFavorite.fire()
    }
}
