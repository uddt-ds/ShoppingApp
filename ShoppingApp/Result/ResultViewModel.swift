//
//  ResultViewModel.swift
//  ShoppingApp
//
//  Created by Lee on 8/12/25.
//

import Foundation

/*
 데이터 배열로 가공해서 넘겨줄게
 */

class ResultViewModel {

    let networkManager = NetworkManager.shared

    var currentCategory: Observable<SortingType> = Observable(value: .accuracy)

    var currentItemData: Observable<ResultData> = Observable(value: .init(total: 0, items: []))

    var errorMessage: Observable<String> = Observable(value: "")

    var suggestItemData: Observable<ResultData> = Observable(value: .init(total: 0, items: []))

    var viewDidLoadTrigger: Observable<Void> = Observable(value: ())

    var start = 1

    // init 시점에 주입받는 데이터
    var keyword: String
    init(_ keyword: String) {
        self.keyword = keyword
        currentCategory.bind { sortType in
            self.fetchData(sortingType: sortType)
        }

        viewDidLoadTrigger.bind { _ in
            self.fetchSuggestData(sortingType: .accuracy)
        }
    }

    private func fetchData(sortingType: SortingType) {

        let queries = networkManager.makeNaverSearchQueries(keyword: keyword, display: QueryData.displayNum, start: start, sortingType: sortingType.rawValue)

        guard let url = networkManager.getURL(scheme: APIData.scheme.rawValue, host: APIData.host.rawValue, path: APIData.path.rawValue, queries: queries) else {
            print(NetworkError.invalidURL.errorMessage)
            return
        }

        guard let headers = APIData.headers else { return }

        networkManager.fetchData(headers: headers, url: url) { (response: Result<ResultData, Error>) in
            switch response {
            case .success(let data):
                self.currentItemData.value = data
                // self.currentItemData.value.append(contentsOf: data.items)

            case .failure(let error):
                if let searchError = error as? SearchError {
                    switch searchError {
                    case .serverError:
                        if let code = searchError.serverErrorLog {
                            print(code.rawValue)
                            print(code.description)
                        }
                        self.errorMessage.value = searchError.serverErrorLog?.userMessage ?? ""
                    default:
                        print(error.localizedDescription)
                    }
                } else if let networkError = error as? NetworkError {
                    switch networkError {
                    default:
                        self.errorMessage.value = networkError.userMessage
                    }
                } else {
                    print(NetworkError.unKnownError.errorMessage)
                }
            }
        }
    }

    private func getKeyword(keywords: String...) -> String {
        guard let keyword = keywords.randomElement() else { return "사과" }
        return keyword
    }

    private func fetchSuggestData(sortingType: SortingType, display: Int = QueryData.displayNum) {

        let keyword = getKeyword(keywords: "아이패드", "맥북", "에어팟", "아이폰", "포터블모니터")

        let queries = networkManager.makeNaverSearchQueries(keyword: keyword, display: QueryData.displayNum, start: start, sortingType: sortingType.rawValue)

        guard let url = networkManager.getURL(scheme: APIData.scheme.rawValue, host: APIData.host.rawValue, path: APIData.path.rawValue, queries: queries) else { return }

        guard let headers = APIData.headers else { return }

        networkManager.fetchData(headers: headers, url: url) { (response: Result<ResultData, Error>) in
            switch response {
            case .success(let data):
                self.suggestItemData.value = data
            case .failure(let error):
                if let searchError = error as? SearchError {
                    switch searchError {
                    case .serverError:
                        if let code = searchError.serverErrorLog {
                            print(code.rawValue)
                            print(code.description)
                        }

                        self.errorMessage.value = searchError.serverErrorLog?.userMessage ?? ""
                    default:
                        print(error.localizedDescription)
                        return
                    }
                }
            }
        }
    }

}
