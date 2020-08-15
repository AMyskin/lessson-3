//
//  Profiles.swift
//  lessson 3
//
//  Created by Alexander Myskin on 29.07.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import Foundation



class Profiles:  Decodable {
    var id: Int
    var firstName: String
    var lastName: String
    var imageUrl: String?
    
     enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case imageUrl = "photo_50"
    }
}
