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

    let accuracyButton = CustomButton(title: ButtonTitle.accuracy.rawValue, tag: 0)
    let dateButton = CustomButton(title: ButtonTitle.date.rawValue, tag: 1)
    let highPriceButton = CustomButton(title: ButtonTitle.highPrice.rawValue, tag: 2)
    let lowPriceButton = CustomButton(title: ButtonTitle.lowPrice.rawValue, tag: 3)

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
        fetchData(sortingType: SortingType.accuracy.rawValue)
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

        // stackView 안에 들어가는 버튼은 동적으로 크기가 바뀌는게 아니라서 forEach로 처리
        [accuracyButton, dateButton, highPriceButton, lowPriceButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }

//        accuracyButton.snp.makeConstraints { make in
//            make.height.equalTo(40)
//        }
//
//        dateButton.snp.makeConstraints { make in
//            make.height.equalTo(40)
//        }
//
//        highPriceButton.snp.makeConstraints { make in
//            make.height.equalTo(40)
//        }
//
//        lowPriceButton.snp.makeConstraints { make in
//            make.height.equalTo(40)
//        }

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
        let sortingTypeArr = SortingType.allCases

        let selectedType = sortingTypeArr[sender.tag]
        fetchData(sortingType: selectedType.rawValue)
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

    private func fetchData(sortingType: SortingType.RawValue, display: Int = QueryData.displayNum) {
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

enum SortingType: String, CaseIterable {
    case accuracy = "sim"
    case date = "date"
    case highPrice = "dsc"
    case lowPrice = "asc"

    // 별도의 struct 또는 enum으로 분리가 되어 있는게 더 유지보수가 유리한 구조일거라고 판단
//    var buttonTitle: String {
//        switch self {
//        case .accuracy: return "정확도"
//        case .date: return "날짜순"
//        case .highPrice: return "가격높은순"
//        case .lowPrice: return "가격낮은순"
//        }
//    }
}

enum ButtonTitle: String {
    case accuracy = "정확도"
    case date = "날짜순"
    case highPrice = "가격높은순"
    case lowPrice = "가격낮은순"
}
