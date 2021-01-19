//
//  DefaultRequesterTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class DefaultRequesterTests: XCTestCase {

    private let requester: DefaultRequester = DefaultRequester()
    
    func testLoadData() {
        let urlRequest = URLRequest(url: URL(string: "test")!)
        let result = requester.loadData(with: urlRequest, completionHandler: { _, _, _ in })
        XCTAssertEqual(result.currentRequest?.url?.absoluteString, "test")
    }
}
