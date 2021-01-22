//
//  EndPoint.swift
//  GifApp
//
//  Created by 신한섭 on 2021/01/19.
//

import Foundation

struct EndPoint {
    
    init(urlInfomation: URLInfomation) {
        self.urlInfomation = urlInfomation
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "/v1/gifs" + urlInfomation.path
        components.queryItems = urlInfomation.queryStinrg
        
        return components.url
    }
    
    private let scheme: String = "https"
    private let host: String = "api.giphy.com"
    private let urlInfomation: URLInfomation
    
    enum URLInfomation {
        case trending
        case autoComplete(keyword: String)
        case search(keyword: String, offset: Int)
        
        var path: String {
            switch self {
            case .trending:
                return "/trending"
            case .autoComplete(_):
                return "/search/tags"
            case .search(_, _):
                return "/search"
            }
        }
        
        var queryStinrg: [URLQueryItem] {
            var result = [URLQueryItem(name: "api_key", value: Secret.APIKey)]
            switch self {
            case .trending:
                return result
            case .autoComplete(let keyword):
                result.append(URLQueryItem(name: "q", value: keyword))
                return result
            case .search(let keyword, let offset):
                result.append(URLQueryItem(name: "q", value: keyword))
                result.append(URLQueryItem(name: "offset", value: "\(offset)"))
                return result
            }
        }
    }
}
