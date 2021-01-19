//
//  DummyRequester.swift
//  GifAppTests
//
//  Created by 신한섭 on 2021/01/19.
//

@testable import GifApp
import Foundation

final class DummyRequester: RequesterType {
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession(configuration: .ephemeral).dataTask(with: URL(string: "test")!)
    }
}
