//
//  ResultData.swift
//  ShoppingApp
//
//  Created by Lee on 7/25/25.
//

import Foundation

struct ResultData: Decodable {
    let total: Int
    let items: [Items]

    var totalCount: String {
        return FormatterManager.getFormatString(style: .decimal, value: total) + "개의 검색결과"
    }
}

struct Items: Decodable {
    let title: String
    let image: String
    let lprice: String
    let mallName: String

    var showTitle: String {
        return title.replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<b>", with: "")
    }

    var wonPrice: String {
        return FormatterManager.getFormatString(style: .decimal, value: Int(lprice) ?? 0) + "원"
    }
}
