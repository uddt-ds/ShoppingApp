//
//  APIData.swift
//  ShoppingApp
//
//  Created by Lee on 7/27/25.
//

import Foundation

enum APIData: String {
    case scheme = "https"
    case host = "openapi.naver.com"
    case path = "/v1/search/shop.json"
}

enum QueryData {
    static let displayNum = 30
}
