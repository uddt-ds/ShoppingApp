//
//  ResultViewController.swift
//  ShoppingApp
//
//  Created by Lee on 7/25/25.
//

import UIKit
import Alamofire

class ResultViewController: BaseViewController {

    let resultCountLabel: UILabel = {
        let label = UILabel()
        label.font = .customFont(.boldSubTitle)
        label.textColor = .systemGreen
        label.textAlignment = .left
        return label
    }()

    let accuracyButton = CustomButton(title: ButtonTitle.accuracy.rawValue)
    let dateButton = CustomButton(title: ButtonTitle.date.rawValue)
    let highPriceButton = CustomButton(title: ButtonTitle.highPrice.rawValue)
    let lowPriceButton = CustomButton(title: ButtonTitle.lowPrice.rawValue)

    var currentData: ResultData = .init(total: 0, items: [])

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [accuracyButton, dateButton, highPriceButton, lowPriceButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    var keyword: String

    init(keyword: String) {
        self.keyword = keyword
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        addButtonTapped()
        collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ResultCollectionViewCell.self))
        fetchData(display: 30, sortingType: SortingType.accuracy.rawValue)
    }

    override func configureViewHierarchy() {
        super.configureViewHierarchy()
        [resultCountLabel, buttonStackView, collectionView].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        super.configureLayout()
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }

        accuracyButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        dateButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        highPriceButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        lowPriceButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-60)
            make.height.equalTo(40)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureUI() {
        super.configureUI()
    }

    private func addButtonTapped() {
        [accuracyButton, dateButton, highPriceButton, lowPriceButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }

    @objc func buttonTapped(_ sender: UIButton) {
        switch sender {
        case accuracyButton:
            fetchData(display: 30, sortingType: SortingType.accuracy.rawValue)
        case dateButton:
            fetchData(display: 30, sortingType: SortingType.date.rawValue)
        case highPriceButton:
            fetchData(display: 30, sortingType: SortingType.highPrice.rawValue)
        case lowPriceButton:
            fetchData(display: 30, sortingType: SortingType.lowPrice.rawValue)
        default:
            return
        }
    }

    func setupNavigation() {
        navigationItem.title = "\(keyword)"
    }

    private func makeCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let deviceWidth = UIScreen.main.bounds.width

        let layout = UICollectionViewFlowLayout()

        let cellWidth = deviceWidth - (16 * 2) - (16 * 1)
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 2 + 68)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical

        return layout
    }

    private func fetchData(display: Int, sortingType: SortingType.RawValue) {
        let networkManager = NetworkManager.shared

        guard let url = networkManager.getURL(keyword: keyword, display: display, sortingType: sortingType) else { return }
        networkManager.fetch(url: url) { response in
            switch response {
            case .success(let data):
                self.currentData = data
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentData.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ResultCollectionViewCell.self), for: indexPath) as? ResultCollectionViewCell else { return .init() }
        cell.configureCell(with: currentData.items[indexPath.row])
        return cell
    }
}

enum SortingType: String {
    case accuracy = "sim"
    case date = "date"
    case highPrice = "dsc"
    case lowPrice = "asc"
}


enum ButtonTitle: String {
    case accuracy = "정확도"
    case date = "날짜순"
    case highPrice = "가격높은순"
    case lowPrice = "가격낮은순"
}
