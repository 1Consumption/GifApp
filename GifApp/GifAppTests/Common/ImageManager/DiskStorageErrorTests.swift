//
//  DiskStorageErrorTests.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/24.
//

@testable import GifApp
import XCTest

final class DiskStorageErrorTests: XCTestCase {

    func testMessage() {
        XCTAssertEqual(DiskStorageError.canNotFoundDocumentDirectory.message, "can't found document directory")
        XCTAssertEqual(DiskStorageError.canNotCreateStorageDirectory(path: "test").message, "can't create storage directory in test")
        XCTAssertEqual(DiskStorageError.storeError(path: "test").message, "can't store value into test")
        XCTAssertEqual(DiskStorageError.removeError(path: "test").message, "can't remove value located at test")
        XCTAssertEqual(DiskStorageError.canNotLoadFileList(path: "test").message, "can't load file list in test")
    }
}
