//
//  CustomError.swift
//  ShoppingApp
//
//  Created by Lee on 7/25/25.
//

import Foundation

enum CustomError: Error {
    case shortInput

    var title: String {
        switch self {
        case .shortInput: return "2글자 이상 입력해주세요"
        }
    }
}
