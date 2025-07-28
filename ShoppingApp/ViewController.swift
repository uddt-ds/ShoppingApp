//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Lee on 7/25/25.
//

import UIKit
import SnapKit

class ViewController: BaseViewController {

    var nickname: String = "영캠러"

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        let title = "브랜드, 상품, 프로필, 태그 등"
        let image = UIImage(systemName: "magnifyingglass")
        searchBar.placeholder = title
        searchBar.setImage(image, for: .resultsList, state: .normal)
        searchBar.searchTextField.font = UIFont.customFont(.subTitle)
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .image
        return imageView
    }()

    let subTitle: UILabel = {
        let label = UILabel()
        label.text = "쇼핑하구팡"
        label.font = .customFont(.boldSubTitle)
        label.textColor = .main
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        searchBar.delegate = self
    }

    override func configureViewHierarchy() {
        super.configureViewHierarchy()
        [searchBar, mainImageView, subTitle].forEach { view.addSubview($0) }
    }

    override func configureUI() {
        super.configureUI()
    }

    override func configureLayout() {
        super.configureLayout()
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        mainImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(40)
            make.height.equalTo(240)
            make.centerY.equalToSuperview()
        }

        subTitle.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(20)
            make.centerX.equalTo(mainImageView.snp.centerX)
            make.height.equalTo(44)
        }
    }

    private func setupNavigation() {
        navigationItem.title = "\(nickname)의 쇼핑쇼핑"
        navigationController?.navigationBar.tintColor = .main
        navigationItem.backButtonTitle = ""
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count >= 2 else {
            super.showAlert(title: SearchError.shortInput.title)
            return
        }

        let vc = ResultViewController(keyword: text)
        navigationController?.pushViewController(vc, animated: true)

        view.endEditing(true)
    }
}
