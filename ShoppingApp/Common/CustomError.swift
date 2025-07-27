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
    case invalidURL
    case failDecoding


    var title: String {
        switch self {
        case .invalidClientID: return "Client ID를 확인해주세요"
        case .invalidClientSecret: return "Client Secret을 확인해주세요"
        case .invalidURL: return "잘못된 URL입니다"
        case .failDecoding: return "디코딩에 실패했습니다"
        }
    }
}

struct DetailError: Decodable {
    let error: ServerError
}

struct ServerError: Decodable {
    let errorMessage: String
    let errorCode: String
}

enum ServerErrorCode: String {
    case SE01 = "400Incorrect query request (잘못된 쿼리요청입니다.)"
    case SE02 = "400Invalid display value (부적절한 display 값입니다.)"
    case SE03 = "400Invalid start value (부적절한 start 값입니다.)"
    case SE04 = "400Invalid sort value (부적절한 sort 값입니다.)"
    case SE05 = "404Invalid search api (존재하지 않는 검색 api 입니다.)"
    case SE06 = "400Malformed encoding (잘못된 형식의 인코딩입니다.)"
    case SE99 = "500System Error (시스템 에러)"

    var description: String {
        switch self {
        case .SE01: return "API 요청 URL의 프로토콜, 파라미터 등에 오류가 있는지 확인합니다."
        case .SE02: return "display 파라미터의 값이 허용 범위의 값(1~100)인지 확인합니다."
        case .SE03: return "start 파라미터의 값이 허용 범위의 값(1~1000)인지 확인합니다."
        case .SE04: return "sort 파라미터의 값에 오타가 있는지 확인합니다."
        case .SE05: return "API 요청 URL에 오타가 있는지 확인합니다."
        case .SE06: return "검색어를 UTF-8로 인코딩합니다."
        case .SE99: return #"서버 내부에 오류가 발생했습니다. "개발자 포럼"에 오류를 신고해 주십시오."#
        }
    }
}
