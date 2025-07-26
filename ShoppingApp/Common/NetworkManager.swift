//
//  NetworkManager.swift
//  ShoppingApp
//
//  Created by Lee on 7/26/25.
//

import Foundation
import Alamofire

struct NetworkManager {
    static let shared = NetworkManager()
//
//    let clientID = (Bundle.main.infoDictionary?["X-Naver-Client-Id"] as? String) ?? ""
//
//    let clientSecret = (Bundle.main.infoDictionary?["X-Naver-Client-Secret"] as? String) ?? ""

    private init() { }

    func getURL(keyword: String, display: Int, sortingType: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "openapi.naver.com"
        components.path = "/v1/search/shop.json"
        components.queryItems = [
           URLQueryItem(name: "query", value: keyword),
           URLQueryItem(name: "display", value: "\(display)"),
           URLQueryItem(name: "sort", value: sortingType)
        ]

        return components.url
    }

    func fetch(url: URL, completion: @escaping (Result<ResultData, Error>) -> Void) {

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
