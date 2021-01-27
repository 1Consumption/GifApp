//
//  MemoryCacheStorage.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import UIKit

final class MemoryCacheStorage<T> {
    
    private var keys: Set<String> = Set<String>()
    private let cache: NSCache<NSString, ExpirableObject<T?>> = NSCache<NSString, ExpirableObject<T?>>()
    private let lock: NSRecursiveLock = NSRecursiveLock()
    private let expireTime: ExpireTime
    
    init(size: Int = 0, expireTime: ExpireTime) {
        cache.totalCostLimit = size
        self.expireTime = expireTime
    }
    
    func insert(_ obejct: T?, for key: String) {
        lock.lock()
        defer { lock.unlock() }
        
        keys.insert(key)
        cache.setObject(ExpirableObject(value: obejct, expireTime: expireTime), forKey: key as NSString)
    }
    
    func remove(for key: String) {
        lock.lock()
        defer { lock.unlock() }
        
        keys.remove(key)
        cache.removeObject(forKey: key as NSString)
    }
    
    func object(for key: String) -> T? {
        lock.lock()
        defer { lock.unlock() }
        
        let object = cache.object(forKey: key as NSString)
        guard object?.isExpired == false else  {
            remove(for: key)
            return nil
        }
        object?.resetExpireTime(expireTime)
        
        return object?.value
    }
    
    func isCached(_ key: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        
        let object = cache.object(forKey: key as NSString)
        guard object?.isExpired == false else  {
            remove(for: key)
            return false
        }
        
        return keys.contains(key)
    }
    
    func removeExpireAll() {
        lock.lock()
        defer { lock.unlock() }
        
        keys.forEach { key in
            guard cache.object(forKey: key as NSString)?.isExpired == true else { return }
            cache.removeObject(forKey: key as NSString)
            keys.remove(key)
        }
    }
}
