//
//  DiskStorage.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/23.
//

import Foundation

final class DiskStorage {
    
    private let fileManager: FileManager
    private let directory: URL
    private let diskQueue: DispatchQueue = DispatchQueue(label: "com.diskQueue")
    
    init(fileManager: FileManager = .default, directoryName: String) throws {
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { throw DiskStorageError.canNotFoundDocumentDirectory }
        self.fileManager = fileManager
        self.directory = documentDirectory.appendingPathComponent(directoryName)
        
        try createDirectory(with: self.directory)
    }
    
    func store(_ value: Data, for key: String) throws {
        let key = cacheKey(key)
        let url = directory.appendingPathComponent(key)
        
        do {
            try value.write(to: url)
        } catch {
            throw DiskStorageError.storeError(path: url.path)
        }
    }
    
    func isStored(_ key: String) -> Bool {
        return fileManager.fileExists(atPath: directory.appendingPathComponent(cacheKey(key)).path)
    }
    
    func data(for key: String) -> Data? {
        let key = cacheKey(key)
        let path = directory.appendingPathComponent(key).path
        
        return fileManager.contents(atPath: path)
    }
    
    func remove(for key: String) throws {
        let key = cacheKey(key)
        let url = directory.appendingPathComponent(key)
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            throw DiskStorageError.removeError(path: url.path)
        }
    }
    
    private func createDirectory(with url: URL) throws {
        guard !fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw DiskStorageError.canNotCreateStorageDirectory(path: url.path)
        }
    }
    
    private func cacheKey(_ key: String) -> String {
        let url = URL(string: key)!
        
        return url.pathComponents.joined().replacingOccurrences(of: "/", with: "")
    }
}
