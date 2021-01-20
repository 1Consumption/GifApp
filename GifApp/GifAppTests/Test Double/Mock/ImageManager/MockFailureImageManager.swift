//
//  MockFailureImageManager.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/21.
//

@testable import GifApp
import XCTest

final class MockFailureImageManager: ImageManagerType {
    
    private var url: String?
    
    func retrieveImage(from url: String, failureHandler: @escaping () -> Void, imageHandler: @escaping (UIImage?) -> Void) -> Cancellable? {
        self.url = url
        
        failureHandler()
        
        return nil
    }
    
    func verify(url: String) {
        self.url = url
    }
}
