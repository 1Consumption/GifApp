//
//  GifInfo.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/18.
//

import Foundation

struct GifInfo {
    let id: String
    let username: String
    let source: String
    let images : GifImages
}

struct GifImages {
    let original: GifImage
    let fixedWidth: GifImage
}

struct GifImage {
    let height: String
    let width: String
    let url: String
}
