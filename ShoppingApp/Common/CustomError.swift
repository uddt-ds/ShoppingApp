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

enum NetworkError: Error {
    case invalidClientID
    case invalidClientSecret
    case failDecoding

    var title: String {
        switch self {
        case .invalidClientID: return "Client ID를 확인해주세요"
        case .invalidClientSecret: return "Client Secret을 확인해주세요"
        case .failDecoding: return "디코딩에 실패했습니다"
        }
    }
}
