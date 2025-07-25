//
//  BaseViewController.swift
//  ShoppingApp
//
//  Created by Lee on 7/25/25.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .bg
        
        configureUI()
        configureViewHierarchy()
        configureLayout()
    }

    func configureUI() {

    }

    func configureLayout() {

    }

    func configureViewHierarchy() {

    }

    func showAlert(title: String) {
        let alert = UIAlertController(title: "경고", message: title, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
