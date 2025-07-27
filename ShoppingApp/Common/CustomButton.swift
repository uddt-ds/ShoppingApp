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

    init(title: String, tag: Int) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.main, for: .normal)
        setTitle(title, for: .selected)
        setTitleColor(.main, for: .selected)
        self.tag = tag
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureUI() {
        titleLabel?.font = UIFont.customFont(.title)
        backgroundColor = .clear
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    private func setupBolderColor() {
        layer.borderColor = UIColor.main.cgColor
    }

    // CGColor는 다크모드 자동 대응이 안됨
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        layer.borderColor = UIColor.main.cgColor
    }
}
