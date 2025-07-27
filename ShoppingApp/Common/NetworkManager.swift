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

    func getURL(keyword: String, display: Int, sortingType: SortingType.RawValue) -> URL? {
        var components = URLComponents()
        components.scheme = APIData.scheme.rawValue
        components.host = APIData.host.rawValue
        components.path = APIData.path.rawValue
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

        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": clientID,
            "X-Naver-Client-Secret": clientSecret
        ]

        // TODO: 에러코드를 파싱해서, 에러 코드에 대한 대응을 어떻게 처리해야할까 고민해보기//
        AF.request(url, headers: headers).responseDecodable(of: ResultData.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if let data = response.data {
                    do {
                        let errorData = try JSONDecoder().decode(ServerError.self, from: data)
                        print(errorData)
                        print(error)
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
