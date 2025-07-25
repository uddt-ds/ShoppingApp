//
//  UIFont+Extension.swift
//  YoungShopping
//
//  Created by Lee on 7/25/25.
//

import UIKit

enum FontSet {
    case title
    case subTitle
    case small

    static let customFontName = "Apple SD Gothic Neo"
}

extension UIFont {
    static func customFont(_ setting: FontSet) -> UIFont {
        switch setting {
        case .title:
            return UIFont(name: FontSet.customFontName, size: 14) ?? systemFont(ofSize: 14)
        case .subTitle:
            return UIFont(name: FontSet.customFontName, size: 12) ?? systemFont(ofSize: 12)
        case .small:
            return UIFont(name: FontSet.customFontName, size: 10) ?? systemFont(ofSize: 12)
        }
    }
}
