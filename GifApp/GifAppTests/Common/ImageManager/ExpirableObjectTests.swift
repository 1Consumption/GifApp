//
//  ExpirableObjectTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import XCTest

final class ExpirableObjectTests: XCTestCase {
    
    func testExpirableObjectHasValue() {
        let data = Data([1, 2, 3])
        let expirableObject = ExpirableObject(value: data, expireTime: .second(1))
        
        XCTAssertEqual(expirableObject.value, data)
    }

    func testIsExpired() {
        let expirableObject1 = ExpirableObject(value: Data(), expireTime: .second(1))
        let expirableObject2 = ExpirableObject(value: Data(), expireTime: .second(3))
        
        sleep(2)
        
        XCTAssertTrue(expirableObject1.isExpired)
        XCTAssertFalse(expirableObject2.isExpired)
    }
    
    func testResetExpireTime() {
        let expirableObject = ExpirableObject(value: Data(), expireTime: .second(3))
        
        sleep(2)
    
        expirableObject.resetExpireTime(.second(3))
        
        sleep(2)
        
        XCTAssertFalse(expirableObject.isExpired)
    }
}
