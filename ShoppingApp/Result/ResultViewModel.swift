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

    var input: Input
    var output: Output

    struct Input {
        var currentCategory: Observable<SortingType> = Observable(value: .accuracy)
        var viewDidLoadTrigger: Observable<Void> = Observable(value: ())
    }

    struct Output {
        var currentItemData: Observable<ResultData> = Observable(value: .init(total: 0, items: []))
        var errorMessage: Observable<String> = Observable(value: "")
        var suggestItemData: Observable<ResultData> = Observable(value: .init(total: 0, items: []))
    }

    let networkManager = NetworkManager.shared

    var start = 1

    // init 시점에 주입받는 데이터
    var keyword: String
    init(_ keyword: String) {
        self.keyword = keyword

        input = Input()
        output = Output()

        input.currentCategory.lazyBind { sortType in
            self.fetchData(sortingType: sortType)
        }

        input.viewDidLoadTrigger.lazyBind { _ in
            self.fetchData()
        }
    }

    private func fetchData(sortingType: SortingType) {
        networkManager.callRequest(api: .normal(key: keyword, start: start, display: QueryData.displayNum, sort: sortingType.rawValue), type: ResultData.self) { response in
            switch response {
            case .success(let value):
                self.output.currentItemData.value = value
            case .failure(let error):
                if let searchError = error as? SearchError {
                    switch searchError {
                    case .serverError:
                        if let code = searchError.serverErrorLog {
                            print(code.rawValue)
                            print(code.description)
                        }
                        self.output.errorMessage.value = searchError.serverErrorLog?.userMessage ?? ""
                    default:
                        print(error.localizedDescription)
                    }
                } else if let networkError = error as? NetworkError {
                    switch networkError {
                    default:
                        self.output.errorMessage.value = networkError.userMessage
                    }
                } else {
                    print(NetworkError.unKnownError.errorMessage)
                }
            }
        }
    }

    private func fetchData() {
        networkManager.callRequest(api: .suggest, type: ResultData.self) { response in
            switch response {
            case .success(let value):
                self.output.suggestItemData.value = value
            case .failure(let error):
                if let searchError = error as? SearchError {
                    switch searchError {
                    case .serverError:
                        if let code = searchError.serverErrorLog {
                            print(code.rawValue)
                            print(code.description)
                        }
                        self.output.errorMessage.value = searchError.serverErrorLog?.userMessage ?? ""
                    default:
                        print(error.localizedDescription)
                    }
                } else if let networkError = error as? NetworkError {
                    switch networkError {
                    default:
                        self.output.errorMessage.value = networkError.userMessage
                    }
                } else {
                    print(NetworkError.unKnownError.errorMessage)
                }
            }
        }
    }

    // TODO: 가변 매개변수와 배열의 차이 고민해보기
    private func getKeyword(keywords: String...) -> String {
        guard let keyword = keywords.randomElement() else { return "사과" }
        return keyword
    }
}
