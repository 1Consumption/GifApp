//
//  MockSuccessImageManager.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/21.
//

@testable import GifApp
import XCTest

final class MockSuccessImageManager: ImageManagerType {
    
    private var url: String?
    
    func retrieveImage(from url: String, failureHandler: @escaping () -> Void, dataHandler: @escaping (Data?) -> Void) -> Cancellable? {
        self.url = url
        
        dataHandler(Data())
        
        return nil
    }
    
    func verify(url: String) {
        XCTAssertEqual(self.url, url)
    }
}

final class MockSuccessCancellableImageManager: ImageManagerType {
    
    private let handler: () -> Void
    
    init(handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    func retrieveImage(from url: String, failureHandler: @escaping () -> Void, dataHandler: @escaping (Data?) -> Void) -> Cancellable? {
        
        return Cancellable { [weak self] in
            self?.handler()
        }
    }
}
