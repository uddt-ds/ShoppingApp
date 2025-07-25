//
//  ResultData.swift
//  ShoppingApp
//
//  Created by Lee on 7/25/25.
//

import Foundation

struct ResultData {
    let total: Int
    let items: [Items]
}

struct Items {
    let title: String
    let image: String
    let lprice: String
    let mallName: String
}
