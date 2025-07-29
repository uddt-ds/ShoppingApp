//
//  SuggestCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Lee on 7/29/25.
//

import UIKit

class SuggestCollectionViewCell: BaseCollectionViewCell {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.designImageView(color: .black)
        imageView.layer.cornerRadius = 12
        return imageView
    }()


    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.addSubview(imageView)
    }

    override func configureLayout() {
        super.configureLayout()

        imageView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }

    override func configureView() {
        super.configureView()
    }
}
