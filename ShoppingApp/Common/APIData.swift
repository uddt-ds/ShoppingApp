//
//  APIData.swift
//  ShoppingApp
//
//  Created by Lee on 7/27/25.
//

import Foundation
import Alamofire

enum APIData: String {
    case scheme = "https"
    case host = "openapi.naver.com"
    case path = "/v1/search/shop.json"

    static var headers: HTTPHeaders? {
        guard let clientID = Bundle.main.infoDictionary?["X-Naver-Client-Id"] as? String else {
            return nil
        }

        guard let clientSecret = Bundle.main.infoDictionary?["X-Naver-Client-Secret"] as? String else {
            print(NetworkError.invalidClientSecret.errorMessage)
            return nil
        }

        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": clientID,
            "X-Naver-Client-Secret": clientSecret
        ]

        return headers
    }
}

