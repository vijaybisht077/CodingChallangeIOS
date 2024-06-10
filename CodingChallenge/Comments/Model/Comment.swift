//
//  Comment.swift
//  CodingChallenge
//
//  Created by vijaybisht on 24/05/24.
//

import Foundation
struct Comment: Codable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
