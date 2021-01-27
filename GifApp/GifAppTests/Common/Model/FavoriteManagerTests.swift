//
//  FavoriteManagerTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/24.
//

@testable import GifApp
import XCTest

final class FavoriteManagerTests: XCTestCase {
    
    private var favoriteManager: FavoriteManager!
    private let gifInfo: GifInfo = GifInfo(id: "1",
                                           username: "",
                                           source: "",
                                           images: GifImages(original: GifImage(height: "", width: "", url: ""),
                                                             fixedWidth: GifImage(height: "", width: "", url: "")),
                                           user: User(avatarUrl: "", username: "", displayName: ""))
    
    override func tearDownWithError() throws {
        NotificationCenter.default.removeObserver(self)
    }
    
    func testFavoriteStateIsFavorite() {
        let expectation = XCTestExpectation(description: "favorite state is favorite")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let data = try! JSONEncoder().encode(gifInfo)
        let diskStorage = MockDiskStorage()
        favoriteManager = FavoriteManager(diskStorage: diskStorage)
        
        favoriteManager.changeFavoriteState(with: gifInfo,
                                            completionHandler: { result in
                                                switch result {
                                                case .success(let factor):
                                                    XCTAssertTrue(factor)
                                                    diskStorage.verifyIsStored(key: self.gifInfo.id)
                                                    diskStorage.verifyStore(value: data, key: self.gifInfo.id)
                                                    expectation.fulfill()
                                                case .failure:
                                                    XCTFail()
                                                }
                                            })
    }
    
    
    func testFavoriteStateIsFavoriteCancel() {
        let expectation = XCTestExpectation(description: "favorite state is favorite cancel")
        expectation.expectedFulfillmentCount = 2
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let data = try! JSONEncoder().encode(gifInfo)
        let diskStorage = MockDiskStorage()
        favoriteManager = FavoriteManager(diskStorage: diskStorage)
        
        try! diskStorage.store(data, for: gifInfo.id)
        
        NotificationCenter.default.addObserver(forName: .FavoriteCancel,
                                               object: nil,
                                               queue: nil,
                                               using: { notification in
                                                guard let gifInfo = notification.userInfo?["gifInfo"] as? GifInfo else { return }
                                                XCTAssertEqual(gifInfo, self.gifInfo)
                                                expectation.fulfill()
                                               })
        
        favoriteManager.changeFavoriteState(with: gifInfo,
                                            completionHandler: { result in
                                                switch result {
                                                case .success(let factor):
                                                    XCTAssertFalse(factor)
                                                    diskStorage.verifyIsStored(key: self.gifInfo.id)
                                                    diskStorage.verifyStore(value: data, key: self.gifInfo.id)
                                                    diskStorage.verifyRemove(key: self.gifInfo.id)
                                                    expectation.fulfill()
                                                case .failure:
                                                    XCTFail()
                                                }
                                            })
    }
    
    func testStoreError() {
        let expectation = XCTestExpectation(description: "store error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let data = try! JSONEncoder().encode(gifInfo)
        let diskStorage = MockDiskStorageThrowStoreError()
        favoriteManager = FavoriteManager(diskStorage: diskStorage)
        
        favoriteManager.changeFavoriteState(with: gifInfo,
                                            completionHandler: { result in
                                                switch result {
                                                case .success:
                                                    XCTFail()
                                                case .failure(let error):
                                                    XCTAssertEqual(error, FavoriteManagerError.diskStorageError(DiskStorageError.storeError(path: self.gifInfo.id)))
                                                    diskStorage.verifyStore(value: data, key: self.gifInfo.id)
                                                    expectation.fulfill()
                                                }
                                            })
    }
    
    func testRemoveError() {
        let expectation = XCTestExpectation(description: "remove error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let data = try! JSONEncoder().encode(gifInfo)
        let diskStorage = MockDiskStorageThrowRemoveError()
        favoriteManager = FavoriteManager(diskStorage: diskStorage)
        
        try! diskStorage.store(data, for: gifInfo.id)
        
        favoriteManager.changeFavoriteState(with: gifInfo,
                                            completionHandler: { result in
                                                switch result {
                                                case .success:
                                                    XCTFail()
                                                case .failure(let error):
                                                    XCTAssertEqual(error, FavoriteManagerError.diskStorageError(DiskStorageError.removeError(path: self.gifInfo.id)))
                                                    diskStorage.verifyRemove(value: data, key: self.gifInfo.id)
                                                    expectation.fulfill()
                                                }
                                            })
    }
    
    func testRetrieveGifInfo() {
        let expectation = XCTestExpectation(description: "retreive gifInfo")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let data = try! JSONEncoder().encode(gifInfo)
        let diskStorage = MockDiskStorage()
        favoriteManager = FavoriteManager(diskStorage: diskStorage)
        
        try! diskStorage.store(data, for: gifInfo.id)
        
        favoriteManager.retrieveGifInfo { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(model, [self.gifInfo])
                diskStorage.verifyItemsInDirectoty()
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testRetrieveGifInfoFailureWithDiskError() {
        let expectation = XCTestExpectation(description: "retreive gifInfo failure with diskError")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let diskStorage = MockDiskStorageThrowLoadFileListError(path: "test")
        favoriteManager = FavoriteManager(diskStorage: diskStorage)
        
        favoriteManager.retrieveGifInfo { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, FavoriteManagerError.diskStorageError(.canNotLoadFileList(path: "test")))
                diskStorage.verifyItemsInDirectoty()
                expectation.fulfill()
            }
        }
    }
}
