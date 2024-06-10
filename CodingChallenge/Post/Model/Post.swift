//
//  Posts.swift
//  CodingChallenge
//
//  Created by vijaybisht on 23/05/24.
//

import Foundation

struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
