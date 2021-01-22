//
//  HTTPMethodTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class HTTPMethodTests: XCTestCase {
    
    func testHTTPMethods() {
        XCTAssertEqual(HTTPMethod.get.rawValue, "GET")
    }
}
