//
//  ExpirableObject.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import Foundation

final class ExpirableObject<T> {
    
    private var expectedExpireTime: Date
    let value: T
    var isExpired: Bool {
        return Date() > expectedExpireTime
    }
    
    init(value: T, expireTime: ExpireTime) {
        self.value = value
        expectedExpireTime = Date(timeIntervalSinceNow: expireTime.timeInterval)
    }
    
    func resetExpireTime(_ expireTime: ExpireTime) {
        expectedExpireTime = Date(timeIntervalSinceNow: expireTime.timeInterval)
    }
}
