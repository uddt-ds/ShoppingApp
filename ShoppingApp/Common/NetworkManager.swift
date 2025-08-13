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

    func callRequest<T: Decodable>(api: SearchRouter,
                                   type: T.Type,
                                   completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = api.endPoint else { return }
        AF.request(url,
                   method: api.method,
                   parameters: api.parameter,
                   encoding: URLEncoding(destination: .queryString),
                   headers: api.headers).responseDecodable(of: T.self) { responseData in
            guard let statusCode = responseData.response?.statusCode else {
                completion(.failure(NetworkError.invalidURL))
                return
            }
            switch statusCode {
            case 200..<300 :
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
}
