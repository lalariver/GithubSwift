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
    
    init() {
        self.fetchUsers(since: nil)
    }
    
    public func nextPage() {
        guard let user = users.last,
              let id = user.id,
              users.count < 100
        else { return }
        self.fetchUsers(since: "\(id)")
    }
    
    private func fetchUsers(since: String?) {
        guard !isFetching else { return }
        isFetching = true
        
        NetworkService.shared.request(api: .getUsers(since: since), model: GithubUsers.self) { [weak self] result in
            self?.isFetching = false
            
            switch result {
            case .success(let users):
                self?.users += users
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}
