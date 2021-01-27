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
    
    func retrieveImage(from url: String, completionHandler: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancellable? {
        self.url = url
        
        completionHandler(.failure(.emptyData))
        
        return nil
    }
    
    func verify(url: String) {
        self.url = url
    }
}
