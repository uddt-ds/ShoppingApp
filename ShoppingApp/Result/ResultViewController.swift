//
//  ResultViewController.swift
//  ShoppingApp
//
//  Created by Lee on 7/25/25.
//

import Foundation

class ResultViewController: BaseViewController {

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
    }

    override func configureViewHierarchy() {
        super.configureViewHierarchy()
    }

    override func configureConstraints() {
        super.configureConstraints()
    }


    override func configureUI() {
        super.configureUI()
    }

    func setupNavigation() {
        navigationItem.title = "\(keyword)"
    }

}
