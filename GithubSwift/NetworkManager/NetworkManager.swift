//
//  NetworkManager.swift
//  GithubSwift
//
//  Created by 黃禾 on 2024/8/13.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func request<T: Codable>(api: GithubApi, model: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        let session = URLSession.shared
        
        let task = session.dataTask(with: api.urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                completion(.failure(.unknownError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do {
                let decodedModel = try decoder.decode(T.self, from: data)
                completion(.success(decodedModel))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}

enum APIError: Error {
    case networkError(Error)
    case serverError(Int)
    case decodingError(Error)
    case unknownError
}
