//
//  NetworkManager.swift
//  GithubSwift
//
//  Created by 黃禾 on 2024/8/13.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func request<T: APIRequest>(apiRequest: T) async throws -> T.ResponseDataType {
        do {
            let request = try apiRequest.makeRequest()
            print("Requesting: \(request)")
            
            return try await withCheckedThrowingContinuation { continuation in
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: APIError.networkError(error))
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode)
                    else {
                        continuation.resume(throwing: APIError.statusCodeError)
                        return
                    }
                    
                    guard let data = data else {
                        continuation.resume(throwing: APIError.dataError)
                        return
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    do {
                        let decodedModel = try decoder.decode(T.ResponseDataType.self, from: data)
                        continuation.resume(returning: decodedModel)
                    } catch {
                        continuation.resume(throwing: APIError.decodingError(error))
                    }
                }
                
                task.resume()
            }
        } catch {
            throw error
        }
    }
}

enum APIError: Error {
    case networkError(Error)
    case serverError(Int)
    case decodingError(Error)
    case unknownError
    case statusCodeError
    case dataError
    case urlError
}
