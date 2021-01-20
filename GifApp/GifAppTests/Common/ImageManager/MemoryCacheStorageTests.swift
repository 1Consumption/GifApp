//
//  MemoryCacheStorageTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/20.
//

@testable import GifApp
import XCTest

final class MemoryCacheStorageTests: XCTestCase {

    func testInsert() {
        let memoryCacheStorage = MemoryCacheStorage<Data>()
        
        memoryCacheStorage.insert(Data([1, 2, 3]), for: "key1")
        memoryCacheStorage.insert(Data([2, 3, 4]), for: "key2")
        
        XCTAssertTrue(memoryCacheStorage.isCached("key1"))
        XCTAssertTrue(memoryCacheStorage.isCached("key2"))
    }
    
    func testRemove() {
        let memoryCacheStorage = MemoryCacheStorage<Data>()
        
        memoryCacheStorage.insert(Data([1, 2, 3]), for: "key1")
        memoryCacheStorage.insert(Data([2, 3, 4]), for: "key2")
        
        memoryCacheStorage.remove(for: "key1")
        
        XCTAssertFalse(memoryCacheStorage.isCached("key1"))
        XCTAssertTrue(memoryCacheStorage.isCached("key2"))
    }
    
    func testObject() {
        let memoryCacheStorage = MemoryCacheStorage<Data>()
        
        memoryCacheStorage.insert(Data([1, 2, 3]), for: "key1")
        
        XCTAssertEqual(memoryCacheStorage.object(for: "key1"), Data([1, 2, 3]))
    }
    
    func testRemoveExpiredAll() {
        let memoryCacheStorage = MemoryCacheStorage<Data>(expireTime: .second(2))
        
        memoryCacheStorage.insert(Data([1, 2, 3]), for: "key1")
        memoryCacheStorage.insert(Data([2, 3, 4]), for: "key2")
        
        sleep(2)
        
        memoryCacheStorage.insert(Data([3, 4, 5]), for: "key3")
        memoryCacheStorage.insert(Data([5, 6, 7]), for: "key4")
        
        sleep(1)
        
        memoryCacheStorage.removeExpireAll()
        
        XCTAssertFalse(memoryCacheStorage.isCached("key1"))
        XCTAssertFalse(memoryCacheStorage.isCached("key2"))
        XCTAssertTrue(memoryCacheStorage.isCached("key3"))
        XCTAssertTrue(memoryCacheStorage.isCached("key4"))
    }
    
    func testReferenceExpiredObject() {
        let memoryCacheStorage = MemoryCacheStorage<Data>(expireTime: .second(2))
        
        memoryCacheStorage.insert(Data([1, 2, 3]), for: "key1")
        memoryCacheStorage.insert(Data([2, 3, 4]), for: "key2")
        
        sleep(1)
        
        let _ = memoryCacheStorage.object(for: "key1")
        
        sleep(1)
        
        XCTAssertNotNil(memoryCacheStorage.object(for: "key1"))
        XCTAssertNil(memoryCacheStorage.object(for: "key2"))
    }
}
