//
//  GifInfoResponse+Equtable+Encodable.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp

extension GifInfoResponse: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.data == rhs.data
    }
}

extension GifInfoResponse: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(data, forKey: .data)
        try container.encode(pagination, forKey: .pagination)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
        case pagination
    }
}

extension Pagination: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(totalCount, forKey: .totalCount)
        try container.encode(count, forKey: .count)
        try container.encode(offset, forKey: .offset)
    }
    
    enum CodingKeys: String, CodingKey {
        case totalCount
        case count
        case offset
    }
}
