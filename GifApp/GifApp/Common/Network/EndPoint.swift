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
        components.queryItems = [URLQueryItem(name: "api_key", value: Secret.APIKey)]
        
        return components.url
    }
    
    private let scheme: String = "https"
    private let host: String = "api.giphy.com"
    private let urlInfomation: URLInfomation
    
    enum URLInfomation {
        case trending
        
        var path: String {
            switch self {
            case .trending:
                return "/trending"
            }
        }
    }
}
