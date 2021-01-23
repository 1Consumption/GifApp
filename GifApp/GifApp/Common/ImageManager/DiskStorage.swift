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
    private var stored: Set<String> = Set<String>()
    
    init(fileManager: FileManager = .default, directoryName: String) {
        self.fileManager = fileManager
        self.directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(directoryName)
        
        guard !fileManager.fileExists(atPath: directory.path) else { return }
        
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
    }
    
    func store(_ value: Data, for key: String) throws {
        
    }
    
    func isStored(_ key: String) -> Bool {
        return true
    }
    
    func data(for key: String) -> Data? {
        return nil
    }
    
    func remove(for key: String) throws {
        
    }
    
    func itemList() -> [String] {
        return []
    }
}
