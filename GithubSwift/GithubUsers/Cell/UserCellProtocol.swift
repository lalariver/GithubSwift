//
//  GithubUserCellModel.swift
//  GithubSwift
//
//  Created by 黃禾 on 2024/8/14.
//

import Foundation

protocol UserCellProtocol {
    var imageURL: String? { get }
    var name: String? { get }
    var subTitleHidden: Bool? { get }
    var id: Int? { get }
}
