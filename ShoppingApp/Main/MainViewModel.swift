//
//  MainViewModel.swift
//  ShoppingApp
//
//  Created by Lee on 8/12/25.
//

import Foundation


final class MainViewModel {

    var input: Input

    struct Input {
        var returnButtonTapped: Observable<String?> = Observable(value: nil)
    }

    var nickname: String = "영캠러"

    init() {
        input = Input()

        input.returnButtonTapped.lazyBind { text in
            self.outputKeywordResult.value = self.validate(text)
        }
    }

    var outputKeywordResult: Observable<Result<String,SearchError>> = Observable(value: .success(""))

    func validate(_ text: String?) -> Result<String, SearchError> {
        guard let text, text.count >= 2 else {
            return .failure(.shortInput)
        }
        return .success(text)
    }

}

