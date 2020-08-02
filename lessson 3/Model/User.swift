

//import UIKit
//
//public struct User {
//    var name: String
//    var image: [UIImage]
//    var newsTest : [NewsOfUser]
//    var avatar: UIImage? {
//        return image.first
//    }
//    
//    
//    
//    
//    static let friendsTotal = (1...50)
//        .map({ _ in fullNameUser })
//        .sorted()
//    
//    static var sectionsOfFriends  =
//        Array(
//            Set(
//                friendsTotal.map ({
//                    String($0.name.prefix(1)).uppercased()
//                })
//            )
//        ).sorted()
//    
//    
//    
//    
//    
//    
//    static var arrayOfFriends:  Array<Array<User>>
//    {
//        var tmp:Array<Array<User>> = []
//        
//        for section in sectionsOfFriends {
//            let letter: String = section
//            tmp.append(friendsTotal.filter { $0.name.hasPrefix(letter) })
//        }
//        return tmp
//        
//    }
//    
//
//    
//
//    
//    
//    public static var fullNameUser: User {
//        
//        let userName = "\(Lorem.firstName) \(Lorem.lastName)"
//        
//        
//        let userImsages: [UIImage] = (1...Int.random(in: 5...15))
//            .map { $0 % 12 }
//            .shuffled()
//            .compactMap({ String($0) })
//            .compactMap({ UIImage(named: $0) })
//        
//        let  newsTest: [NewsOfUser] = (1...Int.random(in: 5...10)).map { _ in
//    
//            
//            return NewsOfUser(
//                author: userName,
//                avatar: userImsages.first,
//                image: (1...Int.random(in: 5...15))
//                    .map { $0 % 12 }
//                    .shuffled()
//                    .compactMap({ String($0) })
//                    .compactMap({ UIImage(named: $0) }),
//                userDate: RandomDate.generateRandomDate(daysBack: 365),
//                
//                date: Date(),
//                newsTest: Lorem.sentences(Int.random(in: 2...5)),
//                countOfViews: Int.random(in: 100...900),
//                countOfLike: Int.random(in: 5...30),
//                isLiked: false
//            )
//        }
//        return  User(name: userName,
//                     image: userImsages,newsTest: newsTest)
//        
//    }
//    
//    
//    
//    
//}
//
//
//
//
//
//
//extension User : Comparable {
//    public static func == (lhs: User, rhs: User) -> Bool {
//        return (lhs.name == rhs.name) && (lhs.newsTest == rhs.newsTest)
//    }
//    
//    
//    
//    
//    public static func < (lhs: User, rhs: User) -> Bool {
//        lhs.name < rhs.name 
//    }
//    
//    
//    
//}
