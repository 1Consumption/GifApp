//
//  MemoryCacheStorageTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import XCTest

final class MemoryCacheStorageTests: XCTestCase {
    
    private var memoryCacheStorage: MemoryCacheStorage<Data>!
    
    func testInsert() {
        memoryCacheStorage = MemoryCacheStorage<Data>(expireTime: .minute(1))
        
        memoryCacheStorage.insert(Data([1, 2, 3]), for: "key1")
        memoryCacheStorage.insert(Data([2, 3, 4]), for: "key2")
        
        XCTAssertTrue(memoryCacheStorage.isCached("key1"))
        XCTAssertTrue(memoryCacheStorage.isCached("key2"))
    }
    
    func testRemove() {
        memoryCacheStorage = MemoryCacheStorage<Data>(expireTime: .minute(1))
        
        memoryCacheStorage.insert(Data([1, 2, 3]), for: "key1")
        memoryCacheStorage.insert(Data([2, 3, 4]), for: "key2")
        
        memoryCacheStorage.remove(for: "key1")
        
        XCTAssertFalse(memoryCacheStorage.isCached("key1"))
        XCTAssertTrue(memoryCacheStorage.isCached("key2"))
    }
    
    func testObject() {
        memoryCacheStorage = MemoryCacheStorage<Data>(expireTime: .minute(1))
        
        memoryCacheStorage.insert(Data([1, 2, 3]), for: "key1")
        
        XCTAssertEqual(memoryCacheStorage.object(for: "key1"), Data([1, 2, 3]))
    }
    
    func testRemoveExpiredAll() {
        let expectation = XCTestExpectation(description: "remove expire all")
        defer { wait(for: [expectation], timeout: 6.0) }
        
        memoryCacheStorage = MemoryCacheStorage<Data>(expireTime: .second(2))
        
        memoryCacheStorage.insert(Data([1, 2, 3]), for: "key1")
        memoryCacheStorage.insert(Data([2, 3, 4]), for: "key2")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            self.memoryCacheStorage.insert(Data([3, 4, 5]), for: "key3")
            self.memoryCacheStorage.insert(Data([5, 6, 7]), for: "key4")
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            self.memoryCacheStorage.removeExpireAll()
            XCTAssertFalse(self.memoryCacheStorage.isCached("key1"))
            XCTAssertFalse(self.memoryCacheStorage.isCached("key2"))
            XCTAssertTrue(self.memoryCacheStorage.isCached("key3"))
            XCTAssertTrue(self.memoryCacheStorage.isCached("key4"))
            expectation.fulfill()
        }
    }
    
    func testReferenceExpiredObject() {
        let expectation = XCTestExpectation(description: "reference expired object")
        defer { wait(for: [expectation], timeout: 4.0) }
        
        memoryCacheStorage = MemoryCacheStorage<Data>(expireTime: .second(2))
        
        memoryCacheStorage.insert(Data([1, 2, 3]), for: "key1")
        memoryCacheStorage.insert(Data([2, 3, 4]), for: "key2")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let _ = self.memoryCacheStorage.object(for: "key1")
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(self.memoryCacheStorage.object(for: "key1"))
            XCTAssertNil(self.memoryCacheStorage.object(for: "key2"))
            expectation.fulfill()
        }
    }
}
