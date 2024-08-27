//
//  UserRepository.swift
//  GithubSwift
//
//  Created by user on 2024/8/27.
//

import Foundation

protocol UserRepository {
    func fetchUsers(since: String?) async throws -> [GithubUser]
    
    func fetchUserDetail(login: String) async throws -> GithubUserDetailModel
}

class DefaultUserRepository: UserRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func fetchUsers(since: String?) async throws -> [GithubUser] {
        let request = GithubApi.GetUsersRequest(since: since)
        return try await NetworkService.shared.request(apiRequest: request)
    }
    
    func fetchUserDetail(login: String) async throws -> GithubUserDetailModel {
        let request = GithubApi.GetUserDetailRequest(login: login)
        return try await NetworkService.shared.request(apiRequest: request)
    }
}
