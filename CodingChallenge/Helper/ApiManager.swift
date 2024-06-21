//
//  ApiManager.swift
//  CodingChallenge
//
//  Created by vijaybisht on 24/05/24.
//

import Foundation
import UIKit
import RxSwift

enum DataError: Error {
    case invalidURL
    case invalidResponse
}

protocol ApiManagerProtocol {
    func request<T: Decodable>(urlString: String) -> Single<T>
}

class ApiManager: ApiManagerProtocol {
    func request<T: Decodable>(urlString: String) -> Single<T> {
        return Single.create { single in
            guard let url = URL(string: urlString) else {
                single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data = data else {
                    single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    single(.success(decodedObject))
                } catch {
                    single(.failure(error))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
