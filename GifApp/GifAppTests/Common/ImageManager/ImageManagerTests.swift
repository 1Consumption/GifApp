//
//  ImageManagerTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import XCTest

final class ImageManagerTests: XCTestCase {
    
    private var imageManager: ImageManager!
    private var data: Data!
    
    override func setUpWithError() throws {
        data = UIImage(named: "heart")!.pngData()!
    }
    
    func testRetrieveImageFromNetwork() {
        let expectation = XCTestExpectation(description: "image from network")
        defer { wait(for: [expectation], timeout: 2.0) }
        
        let networkManager = MockSuccessNetworkManager(data: data)
        let diskStorage = MockDiskStorage()
        imageManager = ImageManager(networkManager: networkManager, diskStorage: diskStorage)
        
        let _ = imageManager.retrieveImage(from: "test",
                                           completionHandler: { result in
                                            switch result {
                                            case .success(let data):
                                                XCTAssertNotNil(data)
                                                networkManager.verify(url: URL(string: "test"),
                                                                      method: .get,
                                                                      headers: nil)
                                                diskStorage.verifyIsStored(key: "test")
                                                diskStorage.verifyStore(value: self.data, key: "test")
                                                expectation.fulfill()
                                            case .failure:
                                                XCTFail()
                                            }
                                           })
    }
    
    func testRetrieveImageWhenRestart() {
        let expectation = XCTestExpectation(description: "image when restart")
        expectation.expectedFulfillmentCount = 1
        defer { wait(for: [expectation], timeout: 3.0) }
        
        let networkManager = DummyNetworkManager()
        let diskStorage = MockDiskStorage()
        
        imageManager = ImageManager(networkManager: networkManager, diskStorage: diskStorage)
        
        try! diskStorage.store(data, for: "test")
        
        let _ = imageManager.retrieveImage(from: "test",
                                           completionHandler: { result in
                                            switch result {
                                            case .success(let data):
                                                XCTAssertNotNil(data)
                                                diskStorage.verifyIsStored(key: "test")
                                                diskStorage.verifyStore(value: self.data, key: "test")
                                                diskStorage.verifyData(key: "test")
                                                expectation.fulfill()
                                            case .failure:
                                                XCTFail()
                                            }
                                           })
    }
    
    func testRetrieveImageFromMemoryCache() {
        let expectation = XCTestExpectation(description: "image from memory cache")
        expectation.expectedFulfillmentCount = 2
        defer { wait(for: [expectation], timeout: 3.0) }
        
        let networkManager = DummyNetworkManager()
        let diskStorage = MockDiskStorage()
        
        imageManager = ImageManager(networkManager: networkManager, diskStorage: diskStorage)
        
        try! diskStorage.store(data, for: "test")
        
        let _ = imageManager.retrieveImage(from: "test",
                                           completionHandler: { result in
                                            switch result {
                                            case .success(let data):
                                                XCTAssertNotNil(data)
                                                expectation.fulfill()
                                            case .failure:
                                                XCTFail()
                                            }
                                           })
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let _ = self.imageManager.retrieveImage(from: "test",
                                                    completionHandler: { result in
                                                        switch result {
                                                        case .success(let data):
                                                            XCTAssertNotNil(data)
                                                            diskStorage.verifyIsStored(key: "test")
                                                            diskStorage.verifyStore(value: self.data, key: "test")
                                                            diskStorage.verifyData(key: "test")
                                                            expectation.fulfill()
                                                        case .failure:
                                                            XCTFail()
                                                        }
                                                    })
        }
    }
    
    func testRetrieveExpiredImageFromCache() {
        let expectation = XCTestExpectation(description: "expired image from cache")
        expectation.expectedFulfillmentCount = 2
        defer { wait(for: [expectation], timeout: 3.0) }
        
        let networkManager = DummyNetworkManager()
        let diskStorage = MockDiskStorage()
        
        imageManager = ImageManager(networkManager: networkManager, expireTime: .second(1), diskStorage: diskStorage)
        
        try! diskStorage.store(data, for: "test")
        
        let _ = imageManager.retrieveImage(from: "test",
                                           completionHandler: { result in
                                            switch result {
                                            case .success(let data):
                                                XCTAssertNotNil(data)
                                                expectation.fulfill()
                                            case .failure:
                                                XCTFail()
                                            }
                                           })
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            let _ = self.imageManager.retrieveImage(from: "test",
                                                    completionHandler: { result in
                                                        switch result {
                                                        case .success(let data):
                                                            XCTAssertNotNil(data)
                                                            diskStorage.verifyIsStored(key: "test", callCount: 2)
                                                            diskStorage.verifyStore(value: self.data, key: "test")
                                                            diskStorage.verifyData(key: "test", callCount: 2)
                                                            expectation.fulfill()
                                                        case .failure:
                                                            XCTFail()
                                                        }
                                                    })
        })
    }
    
    func testReceiveMemoryWarning() {
        let expectation = XCTestExpectation(description: "memory warning")
        defer { wait(for: [expectation], timeout: 5.0) }
        expectation.expectedFulfillmentCount = 2
        
        let networkManager = DummyNetworkManager()
        let diskStorage = MockDiskStorage()
        imageManager = ImageManager(networkManager: networkManager, expireTime: .second(1), diskStorage: diskStorage)
        
        try! diskStorage.store(data, for: "test")
        
        let _ = imageManager.retrieveImage(from: "test",
                                           completionHandler: { result in
                                            switch result {
                                            case .success(let data):
                                                XCTAssertNotNil(data)
                                                expectation.fulfill()
                                            case .failure:
                                                XCTFail()
                                            }
                                           })
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            NotificationCenter.default.post(name: UIApplication.didReceiveMemoryWarningNotification,
                                            object: nil)
            let _ = self.imageManager.retrieveImage(from: "test",
                                                    completionHandler: { result in
                                                        switch result {
                                                        case .success(let data):
                                                            XCTAssertNotNil(data)
                                                            diskStorage.verifyIsStored(key: "test", callCount: 2)
                                                            diskStorage.verifyStore(value: self.data, key: "test")
                                                            diskStorage.verifyData(key: "test", callCount: 2)
                                                            expectation.fulfill()
                                                        case .failure:
                                                            XCTFail()
                                                        }
                                                    })
        })
    }
    
    func testFailure() {
        let expectation = XCTestExpectation(description: "failure")
        defer { wait(for: [expectation], timeout: 1.0) }
        let networkManager = MockFailureNetworkManagerWithNetworkError()
        
        let diskStorage = MockDiskStorage()
        imageManager = ImageManager(networkManager: networkManager, diskStorage: diskStorage)
        
        let _ = imageManager.retrieveImage(from: "test",
                                           completionHandler: { result in
                                            switch result {
                                            case .success:
                                                XCTFail()
                                            case .failure:
                                                networkManager.verify(url: URL(string: "test"),
                                                                      method: .get,
                                                                      headers: nil)
                                                expectation.fulfill()
                                            }
                                           })
    }
    
    func testCancellabel() {
        let expectation = XCTestExpectation(description: "failure")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let diskStorage = MockDiskStorage()
        imageManager = ImageManager(diskStorage: diskStorage)
        
        let cancellable: Cancellable? = imageManager.retrieveImage(from: "www.google.com",
                                                                   completionHandler: { result in
                                                                    switch result {
                                                                    case .success:
                                                                        XCTFail()
                                                                    case .failure:
                                                                        expectation.fulfill()
                                                                    }
                                                                   })
        
        cancellable?.cancel()
    }
    
    func testImageManagerStoreError() {
        let expectation = XCTestExpectation(description: "store error")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let networkManager = MockSuccessNetworkManager(data: data)
        let diskStorage = MockDiskStorageThrowStoreError()
        
        imageManager = ImageManager(networkManager: networkManager, diskStorage: diskStorage)
        
        let _ = imageManager.retrieveImage(from: "test",
                                           completionHandler: { result in
                                            switch result {
                                            case .success(let data):
                                                XCTAssertNotNil(data)
                                                networkManager.verify(url: URL(string: "test"),
                                                                      method: .get,
                                                                      headers: nil)
                                                diskStorage.verifyStore(value: self.data, key: "test")
                                                expectation.fulfill()
                                            case .failure:
                                                XCTFail()
                                            }
                                           })
    }
}
