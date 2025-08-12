//
//  ButtonTitle.swift
//  ShoppingApp
//
//  Created by Lee on 7/27/25.
//

import Foundation

enum ButtonTitle: Int, CaseIterable {
    case accuracy
    case date
    case highPrice
    case lowPrice

    var title: String {
        switch self {
        case .accuracy: return "정확도"
        case .date: return "날짜순"
        case .highPrice: return "가격높은순"
        case .lowPrice: return "가격낮은순"
        }
    }
}
