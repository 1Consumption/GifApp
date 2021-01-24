//
//  FileManagerType.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/24.
//

import Foundation

protocol FileManagerType {
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL]
    func fileExists(atPath path: String) -> Bool
    func contents(atPath path: String) -> Data?
    func removeItem(at URL: URL) throws
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws
}

extension FileManager: FileManagerType { }
