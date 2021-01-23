//
//  DiskStorage.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/23.
//

import Foundation

enum DiskStorageError: Error {
    
    case canNotFoundDocumentDirectory
    case canNotCreateStorageDirectory
    case storeError(path: String)
    case removeError(path: String)
    case itemListError(path: String)
}

final class DiskStorage {
    
    private let fileManager: FileManager
    private let directory: URL
    private var stored: Set<String> = Set<String>()
    
    init(fileManager: FileManager = .default, directoryName: String) throws {
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { throw DiskStorageError.canNotFoundDocumentDirectory }
        self.fileManager = fileManager
        self.directory = documentDirectory.appendingPathComponent(directoryName)
        
        try createDirectory(with: self.directory)
        try loadItemList()
    }
    
    func store(_ value: Data, for key: String) throws {
        let url = directory.appendingPathComponent(key)
        
        do {
            try value.write(to: url)
        } catch {
            throw DiskStorageError.storeError(path: url.path)
        }
        
        stored.insert(key)
    }
    
    func isStored(_ key: String) -> Bool {
        return stored.contains(key)
    }
    
    func data(for key: String) -> Data? {
        let path = directory.appendingPathComponent(key).path
        
        return fileManager.contents(atPath: path)
    }
    
    func remove(for key: String) throws {
        let url = directory.appendingPathComponent(key)
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            throw DiskStorageError.removeError(path: url.path)
        }
        stored.remove(key)
    }
    
    private func createDirectory(with url: URL) throws {
        guard !fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw DiskStorageError.canNotCreateStorageDirectory
        }
    }
    
    private func loadItemList() throws {
        do {
            let items = try fileManager.contentsOfDirectory(atPath: directory.path)
            items.forEach { stored.insert($0) }
        } catch {
            throw DiskStorageError.itemListError(path: directory.path)
        }
    }
}
