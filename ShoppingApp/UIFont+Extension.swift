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
    case boldTitle
    case boldSubTitle
    case boldSmall

    static let normalFont = "Apple SD Gothic Neo"
    static let boldFont = "Apple SD Gothic Neo Bold"
}

extension UIFont {
    static func customFont(_ setting: FontSet) -> UIFont {
        switch setting {
        case .title:
            return UIFont(name: FontSet.normalFont, size: 14) ?? systemFont(ofSize: 14)
        case .subTitle:
            return UIFont(name: FontSet.normalFont, size: 12) ?? systemFont(ofSize: 12)
        case .small:
            return UIFont(name: FontSet.normalFont, size: 10) ?? systemFont(ofSize: 10)
        case .boldTitle:
            return UIFont(name: FontSet.boldFont, size: 14) ?? systemFont(ofSize: 14)
        case .boldSubTitle:
            return UIFont(name: FontSet.boldFont, size: 12) ?? systemFont(ofSize: 12)
        case .boldSmall:
            return UIFont(name: FontSet.boldFont, size: 10) ?? systemFont(ofSize: 10)
        }
    }
}
