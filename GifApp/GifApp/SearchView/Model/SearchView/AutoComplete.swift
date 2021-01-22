//
//  AutoComplete.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/22.
//

import Foundation

struct AutoCompleteResponse: Decodable {
    
    let data: [AutoComplete]
}

struct AutoComplete: Decodable {
    
    let name: String
}
