//
//  AutoComplete+Equtable+Encodable.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/22.
//

@testable import GifApp
import Foundation

extension AutoCompleteResponse: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.data == rhs.data
    }
}

extension AutoCompleteResponse: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(data, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

extension AutoComplete: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}

extension AutoComplete: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
