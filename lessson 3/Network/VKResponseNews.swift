//
//  VKResponse.swift
//  lessson 3
//
//  Created by Alexander Myskin on 01.08.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import Foundation

struct VKResponseNews: Decodable {
    var response: ItemOfNews

}

struct ItemOfNews: Decodable {
    var items: [NewsFeedElement]
    var profiles : [Profiles]
    var groups : [GroupData]
    var nextFrom : String
    
     enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
    
}

