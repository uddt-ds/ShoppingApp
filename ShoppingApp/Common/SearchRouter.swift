//
//  SearchRouter.swift
//  ShoppingApp
//
//  Created by Lee on 8/13/25.
//

import Foundation
import Alamofire

enum QueryData {
    static let displayNum = 100
}

enum SearchRouter {
    case normal(key: String, start: Int, display: Int, sort: SortingType.RawValue)
    case suggest

    var baseURL: String {
        return "https://openapi.naver.com"
    }

    var path: String {
        return "/v1/search/shop.json"
    }

    var endPoint: URL? {
        switch self {
        case .normal:
            return URL(string: baseURL + path)
        case .suggest:
            return URL(string: baseURL + path)
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var headers: HTTPHeaders {
        guard let clientID = Bundle.main.infoDictionary?["X-Naver-Client-Id"] as? String else {
            return .default
        }

        guard let clientSecret = Bundle.main.infoDictionary?["X-Naver-Client-Secret"] as? String else {
            print(NetworkError.invalidClientSecret.errorMessage)
            return .default
        }

        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": clientID,
            "X-Naver-Client-Secret": clientSecret
        ]

        return headers
    }

    var parameter: Parameters {
        switch self {
        case .normal(let key, let start, let display, let sort):
            return [
                "query" : key,
                "start": start,
                "display": display,
                "sort" : sort
            ]
        case .suggest:
            let keywords = ["맥북", "아이폰", "아이패드", "에어팟", "아이팟"]
            let keyword = keywords.randomElement() ?? ""
            return [
                "query" : keyword,
                "start" : "1",
                "display" : "30",
                "sort" : SortingType.accuracy.rawValue
            ]
        }
    }
}
