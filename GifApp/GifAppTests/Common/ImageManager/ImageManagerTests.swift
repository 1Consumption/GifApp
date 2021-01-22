//
//  ImageManagerTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import XCTest

final class ImageManagerTests: XCTestCase {
    
    func testRetrieveImageFromNetwork() {
        let expectation = XCTestExpectation(description: "image from network")
        
        let image = UIImage(named: "heart")
        let data = image!.pngData()!
        
        let networkManager = MockSuccessNetworkManager(data: data)
        let imageManager = ImageManager(networkManager: networkManager)
        
        let _ = imageManager.retrieveImage(from: "test",
                                           failureHandler: { XCTFail() },
                                           imageHandler: {
                                            XCTAssertNotNil($0)
                                            expectation.fulfill()
                                           })
        
        wait(for: [expectation], timeout: 1.0)
        
        networkManager.verify(url: URL(string: "test"), method: .get, headers: nil)
    }
    
    func testRetrieveImageFromCache() {
        let expectation = XCTestExpectation(description: "image from cache")
        expectation.expectedFulfillmentCount = 2
        
        let image = UIImage(named: "heart")
        let data = image!.pngData()!
        
        let networkManager = MockSuccessNetworkManager(data: data)
        
        let imageManager = ImageManager(networkManager: networkManager)
        
        let _ = imageManager.retrieveImage(from: "test",
                                           failureHandler: { XCTFail() },
                                           imageHandler: {
                                            XCTAssertNotNil($0)
                                            expectation.fulfill()
                                           })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let _ = imageManager.retrieveImage(from: "test",
                                               failureHandler: { XCTFail() },
                                               imageHandler: {
                                                XCTAssertNotNil($0)
                                                expectation.fulfill()
                                               })
        })
        
        wait(for: [expectation], timeout: 2.0)
        
        networkManager.verify(url: URL(string: "test"), method: .get, headers: nil)
    }
    
    func testRetrieveExpiredImageFromCache() {
        let expectation = XCTestExpectation(description: "expired image from cache")
        expectation.expectedFulfillmentCount = 2
        
        let image = UIImage(named: "heart")
        let data = image!.pngData()!
        
        let networkManager = MockSuccessNetworkManager(data: data)
        
        let imageManager = ImageManager(networkManager: networkManager, expireTime: .second(1))
        
        let _ = imageManager.retrieveImage(from: "test",
                                           failureHandler: { XCTFail() },
                                           imageHandler: {
                                            XCTAssertNotNil($0)
                                            expectation.fulfill()
                                           })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let _ = imageManager.retrieveImage(from: "test",
                                               failureHandler: { XCTFail() },
                                               imageHandler: {
                                                XCTAssertNotNil($0)
                                                expectation.fulfill()
                                               })
        })
        
        wait(for: [expectation], timeout: 5.0)
            
        networkManager.verify(url: URL(string: "test"), method: .get, headers: nil, callCount: 2)
    }
    
    func testReceiveMemoryWarning() {
        let expectation = XCTestExpectation(description: "memory warning")
        expectation.expectedFulfillmentCount = 2
        
        let image = UIImage(named: "heart")
        let data = image!.pngData()!
        
        let networkManager = MockSuccessNetworkManager(data: data)
        
        let imageManager = ImageManager(networkManager: networkManager, expireTime: .second(1))
        
        let _ = imageManager.retrieveImage(from: "test",
                                           failureHandler: { XCTFail() },
                                           imageHandler: {
                                            XCTAssertNotNil($0)
                                            expectation.fulfill()
                                           })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            NotificationCenter.default.post(name: UIApplication.didReceiveMemoryWarningNotification,
                                            object: nil)
            
            let _ = imageManager.retrieveImage(from: "test",
                                               failureHandler: { XCTFail() },
                                               imageHandler: {
                                                XCTAssertNotNil($0)
                                                expectation.fulfill()
                                               })
        })
        
        wait(for: [expectation], timeout: 5.0)
        
        networkManager.verify(url: URL(string: "test"), method: .get, headers: nil, callCount: 2)
    }
    
    func testFailure() {
        let expectation = XCTestExpectation(description: "failure")
        
        let networkManager = MockFailureNetworkManagerWithNetworkError()
        
        let imageManager = ImageManager(networkManager: networkManager)
        
        let _ = imageManager.retrieveImage(from: "test",
                                           failureHandler: {
                                            expectation.fulfill()
                                           },
                                           imageHandler: { _ in
                                            XCTFail()
                                           })
        
        wait(for: [expectation], timeout: 1.0)
        
        networkManager.verify(url: URL(string: "test"), method: .get, headers: nil)
    }
    
    func testCancellabel() {
        let expectation = XCTestExpectation(description: "failure")
        
        
        let imageManager = ImageManager()
        
        let cancellable: Cancellable? = imageManager.retrieveImage(from: "www.google.com",
                                           failureHandler: {
                                            expectation.fulfill()
                                           },
                                           imageHandler: { _ in
                                            XCTFail()
                                           })
        
        cancellable?.cancel()
        
        wait(for: [expectation], timeout: 1.0)
    }
}
