//
//  ResultViewController.swift
//  ShoppingApp
//
//  Created by Lee on 7/25/25.
//

import UIKit
import Alamofire
import Toast

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
    var currentItemData: [Items] = []
    var currentCategory: SortingType = .accuracy
    var start = 1
    var isEnd: Bool = false


    private lazy var verticalCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var horizontalCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeHorizontalCollectionViewFlowLayout())
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
        verticalCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ResultCollectionViewCell.self))
        horizontalCollectionView.register(SuggestCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: SuggestCollectionViewCell.self))
        fetchData(sortingType: SortingType.accuracy)
    }

    override func configureViewHierarchy() {
        super.configureViewHierarchy()
        [resultCountLabel, buttonStackView, verticalCollectionView, horizontalCollectionView].forEach { view.addSubview($0) }
    }

    override func configureLayout() {
        super.configureLayout()
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }

        [accuracyButton, dateButton, highPriceButton, lowPriceButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-60)
            make.height.equalTo(40)
        }

        verticalCollectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(horizontalCollectionView.snp.top)
        }

        horizontalCollectionView.snp.makeConstraints { make in
            make.top.equalTo(verticalCollectionView.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
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

        start = 1
        isEnd = false
        currentCategory = selectedType
        currentItemData.removeAll()

        fetchData(sortingType: currentCategory)
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

    private func makeHorizontalCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let deviceWidth = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()

        let cellWidth = deviceWidth - (16 * 2) - (8 * 3)
        layout.itemSize = CGSize(width: cellWidth / 4, height: cellWidth / 4)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal

        return layout
    }

    private func fetchData(sortingType: SortingType, display: Int = QueryData.displayNum) {
        let networkManager = NetworkManager.shared

        guard let url = networkManager.getURL(keyword: keyword, display: display, start: start, sortingType: sortingType.rawValue) else {
            return
        }
 
        networkManager.fetch(url: url) { response in
            switch response {
            case .success(let data):
                if !self.isEnd {
                    self.currentData = data
                    self.currentItemData.append(contentsOf: data.items)
                    self.verticalCollectionView.reloadData()
                }

                if self.start == 1 {
                    self.verticalCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }

                DispatchQueue.main.async {
                    self.resultCountLabel.text = self.currentData.totalCount
                    print(self.currentData.totalCount)
                }

                if self.start + QueryData.displayNum > self.currentData.total {
                    self.isEnd = true

                    if self.start != 1 || self.start == 1 && ((self.start - 30) * -1) > self.currentData.total {
                        self.view.makeToast("마지막 페이지입니다", duration: 2.0, position: .bottom)
                    }
                }

            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(#function, indexPaths)
        for indexPath in indexPaths {
            if indexPath.row == (currentItemData.count - 3) && !isEnd {
                start += QueryData.displayNum
                fetchData(sortingType: currentCategory)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == verticalCollectionView {
            return currentItemData.count
        } else if collectionView == horizontalCollectionView {
            return 10
        }

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == verticalCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ResultCollectionViewCell.self), for: indexPath) as? ResultCollectionViewCell else { return .init() }
            cell.configureCell(with: currentItemData[indexPath.row])
            return cell
        } else if collectionView == horizontalCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SuggestCollectionViewCell.self), for: indexPath) as? SuggestCollectionViewCell else { return .init() }
            return cell
        }

        return UICollectionViewCell()
    }
}
