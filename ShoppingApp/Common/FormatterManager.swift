//
//  FormatterManager.swift
//  ShoppingApp
//
//  Created by Lee on 7/26/25.
//

import Foundation

struct FormatterManager {
    static let shared = NumberFormatter()

    private init() { }

    static func getFormatString(style: NumberFormatter.Style, value: Int) -> String {
        FormatterManager.shared.numberStyle = style
        return FormatterManager.shared.string(for: value) ?? ""
    }
}
