//
//  GithubUserDetailViewModel.swift
//  GithubSwift
//
//  Created by 黃禾 on 2024/8/15.
//

import Foundation

class GithubUserDetailViewModel {
    @Published public var imageURL: String?
    @Published public var name: String?
    @Published public var bio: String?
    @Published public var login: String?
    @Published public var subTitleHidden: Bool?
    @Published public var location: String?
    @Published public var blog: String?
    
    init(login: String) {
        self.fetchUserDetail(login: login)
    }
    
    public func saveName(_ name: String?) {
        guard let name = name else { return }
        self.name = name
        self.updateName(name)
    }
    
    private func setUserDetailData(detailModel: GithubUserDetailModel) {
        self.imageURL = detailModel.avatarURL
        self.name = detailModel.name
        self.bio = detailModel.bio
        self.login = detailModel.login
        self.subTitleHidden = detailModel.subTitleHidden
        self.location = detailModel.location ?? "none"
        self.blog = detailModel.blog
    }
    
    private func fetchUserDetail(login: String) {
        NetworkService.shared.request(api: .getUserDetail(login: login), model: GithubUserDetailModel.self) { [weak self] result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self?.setUserDetailData(detailModel: result)
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    private func updateName(_ name: String) {
        // 假設有 api 可以更新 name
    }
}
