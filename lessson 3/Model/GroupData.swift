//
//  GroupData.swift
//  lessson 3
//
//  Created by Alexander Myskin on 01.08.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import Foundation
import RealmSwift

class GroupData: Object, Decodable {
    @objc dynamic var id: Int
    @objc dynamic var name: String
    @objc dynamic var screenName: String
    @objc dynamic var imageUrl: String?
    
    override class func primaryKey() -> String? {
         return "id"
     }
    
     enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case imageUrl = "photo_50"
    }
    

}
