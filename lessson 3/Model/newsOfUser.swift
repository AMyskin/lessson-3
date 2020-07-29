//
//  newsOfUser.swift
//  lessson 2_1
//
//  Created by Alexander Myskin on 01.07.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit

public struct NewsOfUser: Equatable {
    var author: String
    var avatar: UIImage?
    var avatarUrl: String? 
    var image: [UIImage]
    var imageUrl: String?
    var userDate : String
    var date : Date
    var newsTest : String
    var countOfViews : Int
    var countOfLike : Int
    var isLiked : Bool
    
    
    static var randomOne: NewsOfUser {
        return NewsOfUser(
            author: Lorem.fullName,
            avatar: Lorem.photo,
            image: (1...Int.random(in: 5...15))
                .map { $0 % 12 }
                .shuffled()
                .compactMap({ String($0) })
                .compactMap({ UIImage(named: $0) }),
            userDate: RandomDate.generateRandomDate(daysBack: 365),
            date: Date(),
            newsTest: Lorem.sentences(Int.random(in: 2...5)),
            countOfViews: Int.random(in: 100...900),
            countOfLike: Int.random(in: 5...30),
            isLiked: false
        )
    }
    
    

    
    public static func == (lhs: NewsOfUser, rhs: NewsOfUser) -> Bool {
        return lhs.newsTest == rhs.newsTest
            && lhs.userDate == rhs.userDate
            && lhs.countOfViews == rhs.countOfViews
            && lhs.countOfLike == rhs.countOfLike
            && lhs.image == rhs.image
            && lhs.author == rhs.author
            && lhs.isLiked == rhs.isLiked
         && lhs.avatar == rhs.avatar
    }
}
