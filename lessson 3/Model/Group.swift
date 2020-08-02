//
//  Group.swift
//  lessson 2_1
//
//  Created by Alexander Myskin on 20.06.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//
import UIKit


struct Group: Equatable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name &&
            lhs.imageUrl == rhs.imageUrl
    }
    
    var id: Int?
    let name: String
    var imageUrl: String? 
    
    
    
}
