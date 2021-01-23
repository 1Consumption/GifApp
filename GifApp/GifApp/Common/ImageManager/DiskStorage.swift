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
    private let diskQueue: DispatchQueue = DispatchQueue(label: "com.diskQueue")
    
    init(fileManager: FileManager = .default, directoryName: String) throws {
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { throw DiskStorageError.canNotFoundDocumentDirectory }
        self.fileManager = fileManager
        self.directory = documentDirectory.appendingPathComponent(directoryName)
        
        try createDirectory(with: self.directory)
        loadItemList()
    }
    
    func store(_ value: Data, for key: String) throws {
        let url = directory.appendingPathComponent(key)
        
        do {
            try value.write(to: url)
            stored.insert(key)
        } catch {
            throw DiskStorageError.storeError(path: url.path)
        }
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
            stored.remove(key)
        } catch {
            throw DiskStorageError.removeError(path: url.path)
        }
    }
    
    private func createDirectory(with url: URL) throws {
        guard !fileManager.fileExists(atPath: url.path) else { return }
        
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw DiskStorageError.canNotCreateStorageDirectory
        }
    }
    
    private func loadItemList() {
        diskQueue.async {
            do {
                let items = try self.fileManager.contentsOfDirectory(atPath: self.directory.path)
                items.forEach { self.stored.insert($0) }
            } catch {
                debugPrint(error.localizedDescription)
                debugPrint(#function)
            }
        }
    }
}
