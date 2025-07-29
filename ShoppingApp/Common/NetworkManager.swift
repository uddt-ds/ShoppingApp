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

    private init() { }

    func getURL(keyword: String, display: Int, start: Int, sortingType: SortingType.RawValue) -> URL? {
        var components = URLComponents()
        components.scheme = APIData.scheme.rawValue
        components.host = APIData.host.rawValue
        components.path = APIData.path.rawValue
        components.queryItems = [
           URLQueryItem(name: "query", value: keyword),
           URLQueryItem(name: "display", value: "\(display)"),
           URLQueryItem(name: "start", value: "\(start)"),
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

        AF.request(url, headers: headers)
            .responseDecodable(of: ResultData.self) { response in
               guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 200..<300:
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(_):
                        completion(.failure(NetworkError.failDecoding))
                    }
                case 400..<500:
                    if let data = response.data {
                        do {
                            let errorData = try JSONDecoder().decode(ServerError.self, from: data)
                            completion(.failure(SearchError.serverError(code: errorData.errorCode)))
                        } catch {
                            //TODO: AFError에 대한 핸들링은 또 별도로 해줘야 함
                            completion(.failure(error))
                        }
                    }
                default:
                    return
                }
            }
    }

    // TODO: 여기서 어떻게 error Data를 다룰지 고민해봐야함, 에러처리에 대한 분기(여기서 처리를 안하고 error를 넘기고 vc에서 분기)
    func fetch<T: Decodable>(headers: HTTPHeaders, url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url, headers: headers)
            .responseDecodable(of: T.self) { responseData in
                switch responseData.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    // TODO: 상태코드를 받아서 data를 return해야하는데 고민중..
    //    func handleStatus<T: Decodable>(statusCode: Int, data: T) -> T {
    //        switch statusCode {
    //        case 200: return data
    //        case 400: return
    //        }
    //    }
}
