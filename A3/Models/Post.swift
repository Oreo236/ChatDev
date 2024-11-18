//
//  Post.swift
//  A3
//
//  Created by Vin Bui on 10/31/23.
//

import Foundation

struct Post: Codable {
    // TODO: Create a Post Struct here
    let id: String
    let likes: [String]
    let message: String
    let time: Date

    
}

