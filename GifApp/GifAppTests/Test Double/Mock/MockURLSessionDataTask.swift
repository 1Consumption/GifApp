//
//  MockURLSessionDataTask.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
    
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
