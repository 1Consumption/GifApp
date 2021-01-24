//
//  StubFileManager.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/24.
//

@testable import GifApp
import Foundation

final class StubFileManagerThrowCannotFoundDocumentDirectoryError: FileManagerType {
    
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        return []
    }
    
    func contents(atPath path: String) -> Data? {
        return nil
    }
    
    func removeItem(at URL: URL) throws {
    }
    
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
    }

    func fileExists(atPath path: String) -> Bool {
        return false
    }
}


final class StubFileManagerThrowCreateDirectoryError: FileManagerType {
    
    private let dir: String
    
    init(dir: String) {
        self.dir = dir
    }
    
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        return [URL(string: dir)!]
    }
    
    func contents(atPath path: String) -> Data? {
        return nil
    }
    
    func removeItem(at URL: URL) throws {
    }
    
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws {
        throw DiskStorageError.canNotCreateStorageDirectory(path: url.path)
    }

    func fileExists(atPath path: String) -> Bool {
        return false
    }
}
