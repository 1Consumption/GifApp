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

extension GifInfo: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension GifInfo: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(source, forKey: .source)
        try container.encode(images, forKey: .images)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case source
        case images
    }
}

extension GifImages: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(original, forKey: .original)
        try container.encode(fixedWidth, forKey: .fixedWidth)
    }
    
    enum CodingKeys: String, CodingKey {
        case original
        case fixedWidth
    }
}

extension GifImage: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
        try container.encode(url, forKey: .url)
    }
    
    enum CodingKeys: String, CodingKey {
        case height
        case width
        case url
    }
}
