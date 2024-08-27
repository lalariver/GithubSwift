//
//  GithubApi.swift
//  GithubSwift
//
//  Created by 黃禾 on 2024/8/16.
//

import Foundation

// 定義一個協議，用來統一處理不同的 API 請求
protocol APIRequest {
    associatedtype ResponseDataType: Codable
    
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
    
    func makeRequest() throws -> URLRequest
}

// 統一處理 URLRequest 的生成
extension APIRequest {
    var baseURL: String {
        return "https://api.github.com"
    }
    
    var headers: [String: String] {
            return [
                "Accept": "application/vnd.github+json",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        }
    
    func makeRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.urlError
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        return request
    }
}

enum GithubApi {
    // 定義一個具體的 API 請求
    struct GetUsersRequest: APIRequest {
        typealias ResponseDataType = [GithubUser]
        
        var path: String {
            if let since = since, !since.isEmpty {
                return "/users?per_page=20&since=\(since)"
            } else {
                return "/users?per_page=20"
            }
        }
        
        var method: String {
            return "GET"
        }
        
        var parameters: [String: Any]?
        
        private var since: String?
        
        init(since: String?) {
            self.since = since
        }
    }

    // 定義另一個具體的 API 請求
    struct GetUserDetailRequest: APIRequest {
        typealias ResponseDataType = GithubUserDetailModel
        
        var path: String {
            return "/users/\(login)"
        }
        
        var method: String {
            return "GET"
        }
        
        var parameters: [String: Any]? = nil
        
        private var login: String
        
        init(login: String) {
            self.login = login
        }
    }
}
