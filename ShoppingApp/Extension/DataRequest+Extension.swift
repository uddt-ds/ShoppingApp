//
//  DataRequest.swift
//  ShoppingApp
//
//  Created by Lee on 7/26/25.
//

import Foundation
import Alamofire

//extension DataRequest {
//    func slpValidate() -> Self {
//        validate { _, response, data in
//            if response.statusCode == 200 {
//                return .success(())
//            }
//            guard let data else { return .failure(NetworkError.failDecoding)}
//            do {
//                let errorCode = try JSONDecoder().decode(DetailError.self, from: data)
//                return .failure()
//            } catch {
//                return .failure(<#T##any Error#>)
//            }
//        }
//    }
//}
