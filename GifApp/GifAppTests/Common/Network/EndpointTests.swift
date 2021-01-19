//
//  EndpointTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import XCTest

final class EndpointTests: XCTestCase {
    
    func testURL() {
        XCTAssertEqual(EndPoint(urlInfomation: .trending).url?.absoluteString, "https://api.giphy.com/v1/gifs/trending?api_key=\(Secret.APIKey)")
    }
}
