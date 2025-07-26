//
//  ImageView+Extension.swift
//  ShoppingApp
//
//  Created by Lee on 7/25/25.
//

import UIKit

extension UIImageView {
    func designImageView(color: UIColor, mode: UIView.ContentMode = .scaleAspectFill) {
        backgroundColor = color
        clipsToBounds = true
        contentMode = mode
    }
}
