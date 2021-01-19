//
//  ViewModelType.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
