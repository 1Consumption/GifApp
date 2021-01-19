//
//  DefaultRequester.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

final class DefaultRequester: RequesterType {
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    }
}
