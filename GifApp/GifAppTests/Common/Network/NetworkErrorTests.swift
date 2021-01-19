//
//  NetworkErrorTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class NetworkErrorTests: XCTestCase {
    
    func testNetworkError() {
        XCTAssertEqual(NetworkError.emptyURL.message, "empty URL")
        XCTAssertEqual(NetworkError.requestError(description: "test").message, "request error with test")
        XCTAssertEqual(NetworkError.nonHTTPResponseError.message, "response is not HTTP response")
        XCTAssertEqual(NetworkError.invalidHTTPStatusCode(with: 300).message, "invalid HTTP status code: 300")
        XCTAssertEqual(NetworkError.emptyData.message, "empty data")
    }
}
