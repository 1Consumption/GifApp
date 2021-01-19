//
//  UseCaseErrorTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class UseCaseErrorTests: XCTestCase {
    
    func testUseCaseError() {
        XCTAssertEqual(UseCaseError.decodeError.message, "decode error")
        XCTAssertEqual(UseCaseError.networkError(with: .emptyURL).message, "empty URL")
        XCTAssertEqual(UseCaseError.networkError(with: .requestError(description: "error")).message, "request error with error")
        XCTAssertEqual(UseCaseError.networkError(with: .nonHTTPResponseError).message, "response is not HTTP response")
        XCTAssertEqual(UseCaseError.networkError(with: .invalidHTTPStatusCode(with: 300)).message, "invalid HTTP status code: 300")
        XCTAssertEqual(UseCaseError.networkError(with: .emptyData).message, "empty data")
    }
}
