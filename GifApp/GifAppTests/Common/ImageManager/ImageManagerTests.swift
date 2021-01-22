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
    
    func testRetrieveImageFromNetwork() {
        let expectation = XCTestExpectation(description: "image from network")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        let image = UIImage(named: "heart")
        let data = image!.pngData()!
        
        let networkManager = MockSuccessNetworkManager(data: data)
        imageManager = ImageManager(networkManager: networkManager)
        
        let _ = imageManager.retrieveImage(from: "test",
                                           failureHandler: { XCTFail() },
                                           imageHandler: {
                                            XCTAssertNotNil($0)
                                            networkManager.verify(url: URL(string: "test"),
                                                                  method: .get,
                                                                  headers: nil)
                                            expectation.fulfill()
                                           })
    }
    
    func testRetrieveImageFromCache() {
        let expectation = XCTestExpectation(description: "image from cache")
        expectation.expectedFulfillmentCount = 2
        defer { wait(for: [expectation], timeout: 3.0) }
        
        let image = UIImage(named: "heart")
        let data = image!.pngData()!
        
        let networkManager = MockSuccessNetworkManager(data: data)
        
        imageManager = ImageManager(networkManager: networkManager)
        
        let _ = imageManager.retrieveImage(from: "test",
                                           failureHandler: { XCTFail() },
                                           imageHandler: {
                                            XCTAssertNotNil($0)
                                            expectation.fulfill()
                                           })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let _ = self.imageManager.retrieveImage(from: "test",
                                               failureHandler: { XCTFail() },
                                               imageHandler: {
                                                XCTAssertNotNil($0)
                                                networkManager.verify(url: URL(string: "test"),
                                                                      method: .get,
                                                                      headers: nil)
                                                expectation.fulfill()
                                               })
        }
    }
    
    func testRetrieveExpiredImageFromCache() {
        let expectation = XCTestExpectation(description: "expired image from cache")
        expectation.expectedFulfillmentCount = 2
        defer { wait(for: [expectation], timeout: 3.0) }
        
        let image = UIImage(named: "heart")
        let data = image!.pngData()!
        
        let networkManager = MockSuccessNetworkManager(data: data)
        
        imageManager = ImageManager(networkManager: networkManager, expireTime: .second(1))
        
        let _ = imageManager.retrieveImage(from: "test",
                                           failureHandler: { XCTFail() },
                                           imageHandler: {
                                            XCTAssertNotNil($0)
                                            expectation.fulfill()
                                           })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let _ = self.imageManager.retrieveImage(from: "test",
                                               failureHandler: { XCTFail() },
                                               imageHandler: {
                                                XCTAssertNotNil($0)
                                                networkManager.verify(url: URL(string: "test"),
                                                                      method: .get,
                                                                      headers: nil,
                                                                      callCount: 2)
                                                expectation.fulfill()
                                               })
        })
    }
    
    func testReceiveMemoryWarning() {
        let expectation = XCTestExpectation(description: "memory warning")
        defer { wait(for: [expectation], timeout: 5.0) }
        expectation.expectedFulfillmentCount = 2
        
        let image = UIImage(named: "heart")
        let data = image!.pngData()!
        
        let networkManager = MockSuccessNetworkManager(data: data)
        
        imageManager = ImageManager(networkManager: networkManager, expireTime: .second(1))
        
        let _ = imageManager.retrieveImage(from: "test",
                                           failureHandler: { XCTFail() },
                                           imageHandler: {
                                            XCTAssertNotNil($0)
                                            expectation.fulfill()
                                           })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            NotificationCenter.default.post(name: UIApplication.didReceiveMemoryWarningNotification,
                                            object: nil)
            
            let _ = self.imageManager.retrieveImage(from: "test",
                                               failureHandler: { XCTFail() },
                                               imageHandler: {
                                                XCTAssertNotNil($0)
                                                networkManager.verify(url: URL(string: "test"),
                                                                      method: .get,
                                                                      headers: nil, callCount: 2)
                                                expectation.fulfill()
                                               })
        })
    }
    
    func testFailure() {
        let expectation = XCTestExpectation(description: "failure")
        defer { wait(for: [expectation], timeout: 1.0) }
        let networkManager = MockFailureNetworkManagerWithNetworkError()
        
        imageManager = ImageManager(networkManager: networkManager)
        
        let _ = imageManager.retrieveImage(from: "test",
                                           failureHandler: {
                                            networkManager.verify(url: URL(string: "test"),
                                                                  method: .get,
                                                                  headers: nil)
                                            expectation.fulfill()
                                           },
                                           imageHandler: { _ in
                                            XCTFail()
                                           })
    }
    
    func testCancellabel() {
        let expectation = XCTestExpectation(description: "failure")
        defer { wait(for: [expectation], timeout: 1.0) }
        
        imageManager = ImageManager()
        
        let cancellable: Cancellable? = imageManager.retrieveImage(from: "www.google.com",
                                           failureHandler: {
                                            expectation.fulfill()
                                           },
                                           imageHandler: { _ in
                                            XCTFail()
                                           })
        
        cancellable?.cancel()
    }
}
