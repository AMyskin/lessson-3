//
//  GroupData.swift
//  lessson 3
//
//  Created by Alexander Myskin on 01.08.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import Foundation

struct GroupData: Decodable, Equatable {
    let id: Int
    let name: String
    let screenName: String
    var avatar: String?
    
     enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case avatar = "photo_50"
    }
    
    static func == (lhs: GroupData, rhs: GroupData) -> Bool {
        return lhs.name == rhs.name &&
            lhs.id == rhs.id &&
            lhs.screenName == rhs.screenName &&
            lhs.avatar == rhs.avatar
    }
}
