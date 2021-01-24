//
//  GifInfo.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/18.
//

import Foundation

struct GifInfo: Codable {
    
    let id: String
    let username: String
    let source: String
    let images : GifImages
}

struct GifImages: Codable {
    
    let original: GifImage
    let fixedWidth: GifImage
}

struct GifImage: Codable {
    
    let height: String
    let width: String
    let url: String
}


