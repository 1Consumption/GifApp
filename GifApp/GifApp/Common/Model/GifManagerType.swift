//
//  GifManagerType.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import Foundation

protocol GifManagerType {
    
    var gifInfoArray: [GifInfo] { get }
    
    func gifInfo(of index: Int) -> GifInfo?
}

extension GifManagerType {
    
    func gifInfo(of index: Int) -> GifInfo? {
        guard gifInfoArray.count > index else { return nil }
        return gifInfoArray[index]
    }
}

