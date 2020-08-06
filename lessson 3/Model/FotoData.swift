//
//  FotoData.swift
//  lessson 3
//
//  Created by Alexander Myskin on 02.08.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: - FotoData
class FotoData: Object, Codable {

    @objc dynamic var photo1280 : String?
    @objc dynamic var photo130 : String?
    @objc dynamic var photo2560 : String?
    @objc dynamic var photo604: String?
    @objc dynamic var photo75 : String?
    @objc dynamic var photo807: String?


    enum CodingKeys: String, CodingKey {
        case photo1280 = "photo_1280"
        case photo130 = "photo_130"
        case photo2560 = "photo_2560"
        case photo604 = "photo_604"
        case photo75 = "photo_75"
        case photo807 = "photo_807"

    }
}
