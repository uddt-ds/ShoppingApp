//
//  FormatterManager.swift
//  ShoppingApp
//
//  Created by Lee on 7/26/25.
//

import Foundation

struct FormatterManager {
    static let shared = NumberFormatter()

//    //TODO: 연산 타입 프로퍼티와 타입 메서드로 만들었을 때 차이
//    static var shared2: NumberFormatter {
//    }

    private init() { }

    static func getFormatString(style: NumberFormatter.Style, value: Int) -> String {
        FormatterManager.shared.numberStyle = style
        return FormatterManager.shared.string(for: value) ?? ""
    }
}
