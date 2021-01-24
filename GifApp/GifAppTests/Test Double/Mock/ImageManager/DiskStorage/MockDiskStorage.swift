//
//  MockDiskStorage.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/24.
//

@testable import GifApp
import XCTest

final class MockDiskStorage: DiskStorageType {
    
    private var storage: [String: Data] = [String: Data]()
    
    private var storeValue: Data?
    private var storeKey: String?
    private var storeCallCount: Int = 0
    
    private var isStoreKey: String?
    private var isStoreCallCount: Int = 0
    
    private var dataKey: String?
    private var dataCallCount: Int = 0
    
    private var removeKey: String?
    private var removeCallCount: Int = 0
    
    func store(_ value: Data, for key: String) throws {
        storeCallCount += 1
        storeKey = key
        storeValue = value
        storage[key] = value
    }
    
    func isStored(_ key: String) -> Bool {
        isStoreCallCount += 1
        isStoreKey = key
        return storage[key] != nil
    }
    
    func data(for key: String) -> Data? {
        dataCallCount += 1
        dataKey = key
        return storage[key]
    }
    
    func remove(for key: String) throws {
        removeKey = key
        removeCallCount += 1
        storage[key] = nil
    }
    
    func verifyStore(value: Data, key: String, callCount: Int = 1) {
        XCTAssertEqual(storeValue, value)
        XCTAssertEqual(storeKey, key)
        XCTAssertEqual(storeCallCount, callCount)
    }
    
    func verifyIsStored(key: String, callCount: Int = 1) {
        XCTAssertEqual(isStoreKey, key)
        XCTAssertEqual(isStoreCallCount, callCount)
    }
    
    func verifyData(key: String, callCount: Int = 1) {
        XCTAssertEqual(dataKey, key)
        XCTAssertEqual(dataCallCount, callCount)
    }
    
    func verifyRemove(key: String, callCount: Int = 1) {
        XCTAssertEqual(removeKey, key)
        XCTAssertEqual(removeCallCount, callCount)
    }
}

final class MockDiskStorageThrowDirectoryError: DiskStorageType {
    
    init() throws {
        throw DiskStorageError.canNotFoundDocumentDirectory
    }
    
    func store(_ value: Data, for key: String) throws { }
    
    func isStored(_ key: String) -> Bool {
        return true
    }
    
    func data(for key: String) -> Data? {
        return nil
    }
    
    func remove(for key: String) throws { }
}

final class MockDiskStorageThrowStoreError: DiskStorageType {
    
    private var storeValue: Data?
    private var storeKey: String?
    private var storeCallCount: Int = 0
    
    func store(_ value: Data, for key: String) throws {
        storeKey = key
        storeValue = value
        storeCallCount += 1
        throw DiskStorageError.storeError(path: key)
    }
    
    func isStored(_ key: String) -> Bool {
        return false
    }
    
    func data(for key: String) -> Data? {
        return nil
    }
    
    func remove(for key: String) throws { }
    
    func verifyStore(value: Data, key: String, callCount: Int = 1) {
        XCTAssertEqual(storeValue, value)
        XCTAssertEqual(storeKey, key)
        XCTAssertEqual(storeCallCount, callCount)
    }
}

final class MockDiskStorageThrowRemoveError: DiskStorageType {
    
    private var removeKey: String?
    private var removeCallCount: Int = 0
    
    func store(_ value: Data, for key: String) throws { }
    
    func isStored(_ key: String) -> Bool {
        return true
    }
    
    func data(for key: String) -> Data? {
        return nil
    }
    
    func remove(for key: String) throws {
        removeKey = key
        removeCallCount += 1
        throw DiskStorageError.removeError(path: key)
    }
    
    func verifyRemove(value: Data, key: String, callCount: Int = 1) {
        XCTAssertEqual(removeKey, key)
        XCTAssertEqual(removeCallCount, callCount)
    }
}
