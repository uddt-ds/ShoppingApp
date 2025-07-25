//
//  CustomButton.swift
//  ShoppingApp
//
//  Created by Lee on 7/25/25.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.main, for: .normal)
        setTitle(title, for: .selected)
        setTitleColor(.main, for: .selected)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureUI() {
        titleLabel?.font = UIFont.customFont(.title)
        backgroundColor = .clear
        layer.borderColor = UIColor.main.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
