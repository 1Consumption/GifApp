//
//  FavoriteCollectionViewModelTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/25.
//

@testable import GifApp
import XCTest

final class FavoriteCollectionViewModelTests: XCTestCase {
    
    private let input: FavoriteCollectionViewModelInput = FavoriteCollectionViewModelInput()
    private let gifInfo: GifInfo = GifInfo(id: "1",
                                           username: "",
                                           source: "",
                                           images: GifImages(original: GifImage(height: "", width: "", url: ""),
                                                             fixedWidth: GifImage(height: "", width: "", url: "test")))
    private var bag: CancellableBag = CancellableBag()
    private var viewModel: FavoriteCollectionViewModel!
    
    func testOuputFavoriteListDelivered() {
        let expectation = XCTestExpectation(description: "favorite list delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let favoriteManager = MockSuccessFavoriteManager()
        favoriteManager.changeFavoriteState(with: gifInfo, completionHandler: { _ in })
        
        viewModel = FavoriteCollectionViewModel(favoriteManager: favoriteManager)
        
        let output = viewModel.transform(input).favoriteListDelivered
        
        output.bind {
            favoriteManager.verifyRetrieveGifInfo()
            XCTAssertEqual([self.gifInfo], self.viewModel.gifInfoArray)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadFavoriteList.fire()
    }
    
    func testOuputFavoriteListDeliveredWithDuplicatedResult() {
        let expectation = XCTestExpectation(description: "favorite list delivered with duplicated result")
        var count: Int = 0
        defer { wait(for: [expectation], timeout: 4.0) }
        
        let favoriteManager = MockSuccessFavoriteManager()
        favoriteManager.changeFavoriteState(with: gifInfo, completionHandler: { _ in })
        viewModel = FavoriteCollectionViewModel(favoriteManager: favoriteManager)
        
        let output = viewModel.transform(input).favoriteListDelivered
        
        output.bind {
            count += 1
        }.store(in: &bag)
        
        input.loadFavoriteList.fire()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.input.loadFavoriteList.fire()
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            favoriteManager.verifyRetrieveGifInfo(callCount: 2)
            XCTAssertEqual(count, 1)
            XCTAssertEqual(self.viewModel.gifInfoArray, [self.gifInfo])
            expectation.fulfill()
        }
    }
    
    func testOutputFavoriteErrorDelivered() {
        let expectation = XCTestExpectation(description: "favorite error delivered")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let favoriteManager = MockFailureFavoriteManager(error: .diskStorageError(.canNotLoadFileList(path: "test")))
        viewModel = FavoriteCollectionViewModel(favoriteManager: favoriteManager)
        
        let output = viewModel.transform(input).favoriteErrorDelivered
        
        output.bind {
            XCTAssertEqual($0, .diskStorageError(.canNotLoadFileList(path: "test")))
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadFavoriteList.fire()
    }
    
    func testOutputShowDetailFired() {
        let expectation = XCTestExpectation(description: "show detail fire")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let favoriteManager = MockSuccessFavoriteManager()
        favoriteManager.changeFavoriteState(with: gifInfo, completionHandler: { _ in })
        viewModel = FavoriteCollectionViewModel(favoriteManager: favoriteManager)
        
        let output = viewModel.transform(input).showDetailFired
        
        output.bind {
            XCTAssertEqual($0, self.gifInfo)
            expectation.fulfill()
        }.store(in: &bag)
        
        input.loadFavoriteList.fire()
        input.showDetail.value = IndexPath(item: 0, section: 0)
    }
}
