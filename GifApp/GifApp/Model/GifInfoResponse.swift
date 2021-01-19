//
//  GifInfoResponse.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

struct GifInfoResponse: Decodable {
    
    let data: [GifInfo]
    let pagination: Pagination
}

struct Pagination: Decodable {
    
    let totalCount: Int
    let count: Int
    let offset: Int
}
