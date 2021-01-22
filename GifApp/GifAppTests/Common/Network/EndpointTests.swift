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
        XCTAssertEqual(EndPoint(urlInfomation: .autoComplete(keyword: "test")).url?.absoluteString, "https://api.giphy.com/v1/gifs/search/tags?api_key=CQj1AH9PiBcygeVLjkzbR1qvzrnm9GYH&q=test")
        XCTAssertEqual(EndPoint(urlInfomation: .search(keyword: "test", offset: 1)).url?.absoluteString, "https://api.giphy.com/v1/gifs/search?api_key=CQj1AH9PiBcygeVLjkzbR1qvzrnm9GYH&q=test&offset=1")
    }
}
