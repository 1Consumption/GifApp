//
//  DummyImageManager.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/27.
//

@testable import GifApp
import Foundation

final class DummyImageManager: ImageManagerType {
    
    func retrieveImage(from url: String, completionHandler: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancellable? {
        return nil
    }
}
