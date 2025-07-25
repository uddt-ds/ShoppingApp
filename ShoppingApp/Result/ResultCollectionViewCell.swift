//
//  ResultCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Lee on 7/25/25.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.designImageView(color: .black)
        imageView.addSubview(heartImageView)
        return imageView
    }()

    private let heartImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "heart")
        imageView.designImageView(color: .white)
        imageView.image = image

        imageView.tintColor = .black
        imageView.layer.cornerRadius = 18
        return imageView
    }()

    private let mallNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.subTitle)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.subTitle)
        label.textColor = .main
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.boldTitle)
        label.textColor = .main
        label.textAlignment = .left
        return label
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mallNameLabel, titleLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        testLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureHierarchy() {
        [imageView, labelStackView].forEach { contentView.addSubview($0) }
    }

    private func testLabel() {
        mallNameLabel.text = "상점 테스트"
        titleLabel.text = "테스트\n테스트"
        priceLabel.text = "100,000"
    }

    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(labelStackView.snp.top).offset(-4)
        }

        heartImageView.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.trailing.bottom.equalToSuperview().offset(-8)
        }

        mallNameLabel.snp.makeConstraints { make in
            make.height.equalTo(12)
        }

        titleLabel.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(38)
        }

        priceLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }

        labelStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(contentView)
            make.height.equalTo(68)
        }
    }

}
