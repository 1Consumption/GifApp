//
//  ImageRequester.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/20.
//

import Foundation

final class ImageRequester: RequesterType {

    private let session = URLSession(configuration: .ephemeral)
    
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request, completionHandler: completionHandler)
    }
}
