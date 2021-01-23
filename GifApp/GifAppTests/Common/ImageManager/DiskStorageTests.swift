//
//  DiskStorageTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/23.
//

@testable import GifApp
import XCTest

final class DiskStorageTests: XCTestCase {
    
    private var diskStorage: DiskStorage!
    private let fileManager: FileManager = FileManager.default
    private var document: URL!
    
    override func setUpWithError() throws {
        document = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        diskStorage = try! DiskStorage(fileManager: fileManager, directoryName: "test")
    }
    
    func testCreateDirSuccess() {
        XCTAssertTrue(fileManager.fileExists(atPath: document.appendingPathComponent("test").path))
    }
    
    func testStoreAndData() {
        let data = Data([1, 2, 3, 4])
        let key = "key"
        
        try! diskStorage.store(data, for: key)
        
        XCTAssertTrue(diskStorage.isStored(key))
        XCTAssertEqual(diskStorage.data(for: key), data)
    }
    
    func testRemove() {
        let data = Data([1, 2, 3, 4])
        let key = "key"
        
        try! diskStorage.store(data, for: key)
        
        try! diskStorage.remove(for: key)
        
        XCTAssertFalse(diskStorage.isStored(key))
        XCTAssertNil(diskStorage.data(for: key))
    }
    
    func testItemList() {
        let data1 = Data([1, 2, 3, 4])
        let data2 = Data([2, 3, 4, 5])
        let key1 = "key1"
        let key2 = "key2"
        
        try! diskStorage.store(data1, for: key1)
        try! diskStorage.store(data2, for: key2)
        
        diskStorage = try! DiskStorage(fileManager: fileManager, directoryName: "test")

        XCTAssertTrue(diskStorage.isStored(key1))
        XCTAssertTrue(diskStorage.isStored(key2))
    }
    
    override func tearDownWithError() throws {
        try! fileManager.removeItem(atPath: document.appendingPathComponent("test").path)
    }
}
