//
//  ExpireTime.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import Foundation

enum ExpireTime {
    case second(TimeInterval)
    case minute(Double)
    case hour(Double)
    case infinite
    
    var timeInterval: TimeInterval {
        switch self {
        case .second(let time):
            return time
        case .minute(let time):
            return time * 60
        case .hour(let time):
            return time * 3600
        case .infinite:
            return .infinity
        }
    }
}
