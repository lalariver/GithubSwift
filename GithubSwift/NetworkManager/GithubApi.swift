//
//  GithubApi.swift
//  GithubSwift
//
//  Created by 黃禾 on 2024/8/16.
//

import Foundation

enum GithubApi {
    case getUsers(since: String?)
    case getUserDetail(login: String)
    
    var baseURL: String {
        return "https://api.github.com"
    }
    
    var path: String {
        switch self {
        case .getUsers(let since):
            var path = "/users?per_page=20"
            if let since = since {
                path += "&since=\(since)"
            }
            return path
        case .getUserDetail(let login):
            return "/users/\(login)"
        }
    }
    
    var method: String {
        switch self {
        case .getUsers:
            return "GET"
        case .getUserDetail:
            return "GET"
        }
    }
    
    var headers: [String: String] {
        return [
            "Accept": "application/vnd.github+json",
            "Authorization": "Bearer <YOUR_TOKEN>",
            "X-GitHub-Api-Version": "2022-11-28"
        ]
    }
    
    var parameters: [String: String]? {
        switch self {
        case .getUsers:
            return nil
        case .getUserDetail:
            return nil
        }
    }
    
    var urlRequest: URLRequest {
        let urlString = baseURL + path
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        return request
    }
}
