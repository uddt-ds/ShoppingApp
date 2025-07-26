//
//  ResultCollectionViewCell.swift
//  ShoppingApp
//
//  Created by Lee on 7/25/25.
//

import UIKit
import Kingfisher

class ResultCollectionViewCell: UICollectionViewCell {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.designImageView(color: .black)
        imageView.addSubview(heartImageView)
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private let heartImageView: UIImageView = {
        let imageView = UIImageView()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .light)
        let image = UIImage(systemName: "heart", withConfiguration: symbolConfiguration)
        imageView.designImageView(color: .white, mode: .center)
        imageView.image = image
        imageView.tintColor = .black
        imageView.layer.cornerRadius = 18
        return imageView
    }()

    private let mallNameLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.small)
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
        stackView.distribution = .fill
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureHierarchy() {
        [imageView, labelStackView].forEach { contentView.addSubview($0) }
    }

    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(imageView.snp.width)
        }

        heartImageView.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.trailing.bottom.equalToSuperview().offset(-8)
        }

        mallNameLabel.snp.makeConstraints { make in
            make.height.equalTo(12)
        }

        titleLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(18)
        }

        priceLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }

        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.leading.trailing.equalTo(contentView)
            make.height.greaterThanOrEqualTo(48)
        }
    }

    func configureCell(with data: Items) {
        guard let url = URL(string: data.image) else {
            print("잘못된 URL입니다")
            return
        }

        imageView.kf.setImage(with: url, options: [
            .keepCurrentImageWhileLoading
        ])
        mallNameLabel.text = data.mallName
        titleLabel.text = data.showTitle
        priceLabel.text = data.wonPrice
    }
}
