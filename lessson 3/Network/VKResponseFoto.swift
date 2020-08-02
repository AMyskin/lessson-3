//
//  VKResponseFoto.swift
//  lessson 3
//
//  Created by Alexander Myskin on 02.08.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//


import Foundation
struct VKResponseFoto: Decodable {
    var response: ItemOfFoto

}

struct ItemOfFoto: Decodable {
    var items: [FotoData]


    
}
