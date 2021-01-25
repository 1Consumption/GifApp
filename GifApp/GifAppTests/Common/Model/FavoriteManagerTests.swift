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
                                                             fixedWidth: GifImage(height: "", width: "", url: "")))
    
    func testFavoriteStateIsFavorite() {
        let expectation = XCTestExpectation(description: "favorite state is favorite")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let data = try! JSONEncoder().encode(gifInfo)
        let diskStorage = MockDiskStorage()
        favoriteManager = FavoriteManager(diskStorage: diskStorage)
        
        favoriteManager.changeFavoriteState(with: gifInfo,
                                            failureHandler: { _ in
                                              XCTFail()
                                            }, successHandler: {
                                                XCTAssertTrue($0)
                                                diskStorage.verifyIsStored(key: self.gifInfo.id)
                                                diskStorage.verifyStore(value: data, key: self.gifInfo.id)
                                                expectation.fulfill()
                                            })
    }
    
    func testFavoriteStateIsFavoriteCancel() {
        let expectation = XCTestExpectation(description: "favorite state is favorite cancel")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let data = try! JSONEncoder().encode(gifInfo)
        let diskStorage = MockDiskStorage()
        favoriteManager = FavoriteManager(diskStorage: diskStorage)

        try! diskStorage.store(data, for: gifInfo.id)
        
        favoriteManager.changeFavoriteState(with: gifInfo,
                                            failureHandler: { _ in
                                              XCTFail()
                                            }, successHandler: {
                                                XCTAssertFalse($0)
                                                diskStorage.verifyIsStored(key: self.gifInfo.id)
                                                diskStorage.verifyStore(value: data, key: self.gifInfo.id)
                                                diskStorage.verifyRemove(key: self.gifInfo.id)
                                                expectation.fulfill()
                                            })
    }
    
    func testStoreError() {
        let expectation = XCTestExpectation(description: "store error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let data = try! JSONEncoder().encode(gifInfo)
        let diskStorage = MockDiskStorageThrowStoreError()
        favoriteManager = FavoriteManager(diskStorage: diskStorage)
        
        favoriteManager.changeFavoriteState(with: gifInfo,
                                            failureHandler: { error in
                                                XCTAssertEqual(error, FavoriteManagerError.diskStorageError(DiskStorageError.storeError(path: self.gifInfo.id)))
                                                diskStorage.verifyStore(value: data, key: self.gifInfo.id)
                                                expectation.fulfill()
                                            }, successHandler: { _ in
                                                XCTFail()
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
                                            failureHandler: { error in
                                                XCTAssertEqual(error, FavoriteManagerError.diskStorageError(DiskStorageError.removeError(path: self.gifInfo.id)))
                                                diskStorage.verifyRemove(value: data, key: self.gifInfo.id)
                                                expectation.fulfill()
                                            }, successHandler: { _ in
                                                XCTFail()
                                            })
    }
    
    func testRetrieveGifInfo() {
        let expectation = XCTestExpectation(description: "retreive gifInfo")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let data = try! JSONEncoder().encode(gifInfo)
        let diskStorage = MockDiskStorage()
        favoriteManager = FavoriteManager(diskStorage: diskStorage)
        
        try! diskStorage.store(data, for: gifInfo.id)
        
        favoriteManager.retrieveGifInfo(failureHandler: { _ in
            XCTFail()
        }, successHandler: {
            XCTAssertEqual($0, [self.gifInfo])
            diskStorage.verifyItemsInDirectoty()
            expectation.fulfill()
        })
    }
    
    func testRetrieveGifInfoFailureWithDiskError() {
        let expectation = XCTestExpectation(description: "retreive gifInfo failure with diskError")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let diskStorage = MockDiskStorageThrowLoadFileListError(path: "test")
        favoriteManager = FavoriteManager(diskStorage: diskStorage)
        
        favoriteManager.retrieveGifInfo(failureHandler: {
            XCTAssertEqual($0, FavoriteManagerError.diskStorageError(.canNotLoadFileList(path: "test")))
            diskStorage.verifyItemsInDirectoty()
            expectation.fulfill()
        }, successHandler: { _ in
            XCTFail()
        })
    }
}
