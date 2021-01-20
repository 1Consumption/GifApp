//
//  ExpireTimeTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import XCTest

final class ExpireTimeTests: XCTestCase {

    func testExpireTime() {
        XCTAssertEqual(ExpireTime.second(20).timeInterval, 20)
        XCTAssertEqual(ExpireTime.minute(2).timeInterval, 120)
        XCTAssertEqual(ExpireTime.hour(2).timeInterval, 7200)
        XCTAssertEqual(ExpireTime.infinite.timeInterval, .infinity)
    }
}
