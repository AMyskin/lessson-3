//
//  Profiles.swift
//  lessson 3
//
//  Created by Alexander Myskin on 29.07.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import Foundation


struct Profiles: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    var imageUrl: String?
    
     enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case imageUrl = "photo_50"
    }
}
