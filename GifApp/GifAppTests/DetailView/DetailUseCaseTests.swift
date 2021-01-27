//
//  DetailUseCaseTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/27.
//

@testable import GifApp
import XCTest

final class DetailUseCaseTests: XCTestCase {

    private var detailUseCase: DetailUseCase!
    private let gifInfo: GifInfo = GifInfo(id: "1",
                                           username: "",
                                           source: "",
                                           images: GifImages(original: GifImage(height: "", width: "", url: ""),
                                                             fixedWidth: GifImage(height: "", width: "", url: "test")),
                                           user: User(avatarUrl: "", username: "", displayName: ""))
    
    func testRetrieveImageSuccess() {
        let expectation = XCTestExpectation(description: "retrieve image")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let imageManager = MockSuccessImageManager()
        let favoriteManager = DummyFavoriteManager()
        
        detailUseCase = DetailUseCase(imageManager: imageManager, favoriteManager: favoriteManager)
        
        detailUseCase.retrieveImage(with: "test") { result in
            switch result {
            case .success:
                imageManager.verify(url: "test")
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testRetrieveImageFailure() {
        let expectation = XCTestExpectation(description: "retrieve image failure")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let imageManager = MockSuccessImageManager()
        let favoriteManager = DummyFavoriteManager()
        
        detailUseCase = DetailUseCase(imageManager: imageManager, favoriteManager: favoriteManager)
        
        detailUseCase.retrieveImage(with: "test") { result in
            switch result {
            case .success:
                XCTFail()
            case .failure:
                imageManager.verify(url: "test")
                expectation.fulfill()
            }
        }
    }
    
    func testSendFavoriteStateChange() {
        let expectation = XCTestExpectation(description: "send favorite state change")
        expectation.expectedFulfillmentCount = 2
        defer { wait(for: [expectation], timeout: 3.0) }
        
        let imageManager = DummyImageManager()
        let favoriteManager = MockSuccessFavoriteManager()
        
        detailUseCase = DetailUseCase(imageManager: imageManager, favoriteManager: favoriteManager)
        
        detailUseCase.sendFavoriteStateChange(gifInfo: gifInfo) { result in
            switch result {
            case .success(let factor):
                XCTAssertTrue(factor)
                favoriteManager.verifyChangeFavoriteState(gifInfo: self.gifInfo, storageCount: 1)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
            self.detailUseCase.sendFavoriteStateChange(gifInfo: self.gifInfo) { result in
                switch result {
                case .success(let factor):
                    XCTAssertFalse(factor)
                    favoriteManager.verifyChangeFavoriteState(gifInfo: self.gifInfo, storageCount: 0)
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            }
        })
    }
    
    func testSendFavoriteStateChangeFailure() {
        let expectation = XCTestExpectation(description: "send favorite state change failure")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let imageManager = DummyImageManager()
        let favoriteManager = MockFailureFavoriteManager(error: .encodeError)
        
        detailUseCase = DetailUseCase(imageManager: imageManager, favoriteManager: favoriteManager)
        
        detailUseCase.sendFavoriteStateChange(gifInfo: gifInfo) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .encodeError)
                favoriteManager.verifyChangeFavoriteState(gifInfo: self.gifInfo)
                expectation.fulfill()
            }
        }
    }
    
    func testRetrieveIsFavoriteGifInfo() {
        let expectation = XCTestExpectation(description: "retrieve isFavorite gifInfo")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let imageManager = DummyImageManager()
        let favoriteManager = MockSuccessFavoriteManager()
        
        detailUseCase = DetailUseCase(imageManager: imageManager, favoriteManager: favoriteManager)
        
        detailUseCase.sendFavoriteStateChange(gifInfo: gifInfo) { _ in }
        
        detailUseCase.retrieveIsFavoriteGifInfo(gifInfo: gifInfo) { result in
            switch result {
            case .success(let factor):
                XCTAssertTrue(factor)
                favoriteManager.verifyRetrieveGifInfo()
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testRetrieveIsFavoriteGifInfoFailure() {
        let expectation = XCTestExpectation(description: "retrieve isFavorite gifInfo")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let imageManager = DummyImageManager()
        let favoriteManager = MockFailureFavoriteManager(error: .diskStorageError(.canNotFoundDocumentDirectory))
        
        detailUseCase = DetailUseCase(imageManager: imageManager, favoriteManager: favoriteManager)
        
        detailUseCase.retrieveIsFavoriteGifInfo(gifInfo: gifInfo) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .diskStorageError(.canNotFoundDocumentDirectory))
                favoriteManager.verifyRetrieveGifInfo()
                expectation.fulfill()
            }
        }
    }
}
