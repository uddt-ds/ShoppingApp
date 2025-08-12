//
//  Observable.swift
//  ShoppingApp
//
//  Created by Lee on 8/12/25.
//

import Foundation

final class Observable<T> {

    var action: ((T) -> Void)?

    var value: T {
        didSet {
            print("Observable DidSet")
            action?(value)
        }
    }

    init(value: T) {
        self.value = value
    }

    func bind(closure: @escaping ((T) -> Void)) {
        action?(value)
        self.action = closure
    }

    func lazyBind(closure: @escaping ((T) -> Void)) {
        self.action = closure
    }
}
