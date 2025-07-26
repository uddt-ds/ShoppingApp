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

    let accuracyButton = CustomButton(title: "정확도")
    let dateButton = CustomButton(title: "날짜순")
    let highPriceButton = CustomButton(title: "가격 높은 순")
    let lowPriceButton = CustomButton(title: "가격 낮은 순")

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
        testUI()
        collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ResultCollectionViewCell.self))
    }

    private func testUI() {
        resultCountLabel.text = "검색결과"
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

    private func fetch(completion: @escaping (Result<ResultData, Error>) -> Void) {

        guard let clientID = Bundle.main.infoDictionary?["X-Naver-Client-Id"] as? String else {
            completion(.failure(NetworkError.invalidClientID))
            return
        }
        guard let clientSecret = Bundle.main.infoDictionary?["X-Naver-Client-Secret"] as? String else {
            completion(.failure(NetworkError.invalidClientSecret))
            return
        }

        let headers = HTTPHeaders([
            HTTPHeader(name: "X-Naver-Client-Id", value: clientID),
            HTTPHeader(name: "X-Naver-Client-Secret", value: clientSecret)
        ])

        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(keyword)&display=100"

        AF.request(url, headers: headers).responseDecodable(of: ResultData.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                completion(.failure(NetworkError.failDecoding))
            }
        }
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ResultCollectionViewCell.self), for: indexPath) as? ResultCollectionViewCell else { return .init() }
        fetch { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let count = FormatterManager.getFormatString(style: .decimal, value: data.total)
                    self.resultCountLabel.text = "\(count)개의 검색 결과"
                    cell.configureCell(with: data.items[indexPath.item])
                }
            case .failure(let error):
                print(error)
            }
        }
        return cell
    }
}

}
