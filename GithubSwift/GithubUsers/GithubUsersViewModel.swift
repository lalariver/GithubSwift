//
//  GithubUserViewModel.swift
//  GithubSwift
//
//  Created by 黃禾 on 2024/8/14.
//

import Foundation

class UsersViewModel: ObservableObject {
    @Published var users: [UserCellProtocol] = []
    @Published var errorMessage: String? = nil
    
    private var isFetching = false
    
    private let userRepository: UserRepository
        
    init(userRepository: UserRepository = DefaultUserRepository()) {
        self.userRepository = userRepository
        self.startFetching()
    }
    
    public func nextPage() {
        guard let user = users.last,
              let id = user.id,
              users.count < 100
        else { return }
        Task {
            await self.fetchUsers(since: "\(id)")
        }
    }
    
    private func startFetching() {
        Task {
            await fetchUsers(since: nil)
//            This will wait for fetchUsers to complete before calling fetchXxxxxx
//            await fetchXxxxxx
        }

        Task {
            // This will not wait for fetchUsers to complete before calling fetchAaaaa
            // await fetchAaaaa
        }

    }
    
    private func fetchUsers(since: String?) async {
        guard !isFetching else { return }
        isFetching = true
        
        do {
            let _users = try await userRepository.fetchUsers(since: since)
            await MainActor.run {
                users += _users
                isFetching = false
            }
        } catch {
            isFetching = false
            print("Error fetching users: \(error)")
        }
    }
}
