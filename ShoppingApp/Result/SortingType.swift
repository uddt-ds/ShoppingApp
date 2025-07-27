//
//  SortingType.swift
//  ShoppingApp
//
//  Created by Lee on 7/27/25.
//

import Foundation

enum SortingType: String, CaseIterable {
    case accuracy = "sim"
    case date = "date"
    case highPrice = "dsc"
    case lowPrice = "asc"

    // 별도의 struct 또는 enum으로 분리가 되어 있는게 더 유지보수가 유리한 구조일거라고 판단
//    var buttonTitle: String {
//        switch self {
//        case .accuracy: return "정확도"
//        case .date: return "날짜순"
//        case .highPrice: return "가격높은순"
//        case .lowPrice: return "가격낮은순"
//        }
//    }
}
