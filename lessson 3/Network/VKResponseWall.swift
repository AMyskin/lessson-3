//
//  VKResponseWall.swift
//  lessson 3
//
//  Created by Alexander Myskin on 01.08.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import Foundation
struct VKResponseWall: Decodable {
    var response: ItemOfWall

}

struct ItemOfWall: Decodable {
    var items: [WallUserElement]


    
}
