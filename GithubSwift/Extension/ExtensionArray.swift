//
//  ExtensionArray.swift
//  GithubSwift
//
//  Created by 黃禾 on 2024/8/15.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            return indices.contains(index) ? self[index] : nil
        }
        set {
            if let newValue = newValue, indices.contains(index) {
                self[index] = newValue
            }
        }
    }
}

