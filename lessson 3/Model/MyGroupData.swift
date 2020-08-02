//
//  MyGroupData.swift
//  lessson 3
//
//  Created by Alexander Myskin on 28.07.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import Foundation

// MARK: - MyGroupElement
struct MyGroupData: Codable {
    let id: Int
    let name, screenName: String
    let photo50, photo100, photo200: String?
    

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
       
    }
}



