//
//  NetworkManager.swift
//  ShoppingApp
//
//  Created by Lee on 7/26/25.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()

    private init() { }

    // 파라미터를 모델로 만들고, 제네릭 타입이나 프로토콜 활용
    // 라우터 패턴 (나중에 리캡 다 끝나고 공부)

    // MARK: URL 정의하는 메서드
    func getURL(scheme: String, host: String, path: String, queries: [URLQueryItem]) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queries
        return components.url
    }

    // MARK: 데이터 불러오는 제네릭 메서드
    func fetchData<T: Decodable>(headers: HTTPHeaders, url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url, headers: headers)
            .responseDecodable(of: T.self) { responseData in
                guard let statusCode = responseData.response?.statusCode else {
                    completion(.failure(NetworkError.invalidURL))
                    return
                }
                switch statusCode {
                case 200..<300:
                    switch responseData.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(.failure(NetworkError.failDecoding))
                    }
                case 400...500:
                    if let data = responseData.data {
                        do {
                            let errorData = try JSONDecoder().decode(ServerError.self, from: data)
                            completion(.failure(SearchError.serverError(code: errorData.errorCode)))
                        } catch {
                            completion(.failure(NetworkError.noData))
                        }
                    }
                default:
                    completion(.failure(NetworkError.unKnownError))
                }

            }
    }

    // 얘는 종속된 메서드(네이버에만 쓸 수 있는 상태)
    func makeNaverSearchQueries(keyword: String, display: Int, start: Int, sortingType: SortingType.RawValue) -> [URLQueryItem] {
        let queries = [
            URLQueryItem(name: "query", value: keyword),
            URLQueryItem(name: "display", value: "\(display)"),
            URLQueryItem(name: "start", value: "\(start)"),
            URLQueryItem(name: "sort", value: sortingType)
        ]

        return queries
    }
}
