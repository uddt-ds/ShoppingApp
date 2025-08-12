//
//  MainViewModel.swift
//  ShoppingApp
//
//  Created by Lee on 8/12/25.
//

import Foundation

/*
 VM 역할:
 닉네임 전달
 검색 관련 로직 점검
 */

final class MainViewModel {
    var nickname: String = "영캠러"

    func validate(_ text: String?) -> Result<String, Error> {
        guard let text, text.count >= 2 else {
            return .failure(SearchError.shortInput)
        }

        return .success(text)
    }

}

