//
//  GithubUserModel.swift
//  Github
//
//  Created by 黃禾 on 2024/8/13.
//

import Foundation

// MARK: - GithubUser
struct GithubUser: Codable {
    var login: String?
    var id: Int?
    var nodeID: String?
    var avatarURL: String?
    var gravatarID: String?
    var url, htmlURL, followersURL: String?
    var followingURL, gistsURL, starredURL: String?
    var subscriptionsURL, organizationsURL, reposURL: String?
    var eventsURL: String?
    var receivedEventsURL: String?
    var type: String?
    var siteAdmin: Bool?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}

typealias GithubUsers = [GithubUser]

extension GithubUser: UserCellProtocol {
    var imageURL: String? {
        return avatarURL
    }
    
    var name: String? {
        return login
    }
    
    var subTitleHidden: Bool? {
        return !(siteAdmin ?? false)
    }
}
