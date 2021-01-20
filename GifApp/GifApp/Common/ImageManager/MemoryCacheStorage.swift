//
//  MemoryCacheStorage.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import UIKit

final class MemoryCacheStorage<T> {
    
    private var keys: Set<String> = Set<String>()
    private let cache: NSCache<NSString, ExpirableObject<T>> = NSCache<NSString, ExpirableObject<T>>()
    private let lock: NSLock = NSLock()
    private let expireTime: ExpireTime
    
    init(size: Int = 0, expireTime: ExpireTime = .minute(1)) {
        cache.totalCostLimit = size
        self.expireTime = expireTime
    }
    
    func insert(_ obejct: T, for key: String) {
        lock.lock()
        defer { lock.unlock() }
        
        keys.insert(key)
        cache.setObject(ExpirableObject(value: obejct, expireTime: expireTime), forKey: key as NSString)
    }
    
    func remove(for key: String) {
        
    }
    
    func object(for key: String) -> T? {
        return nil
    }
    
    func isCached(_ key: String) -> Bool {
        return keys.contains(key)
    }
    
    func removeExpireAll() {
        
    }
}
