//
//  FriendsNetwork.swift
//  lessson 3
//
//  Created by Alexander Myskin on 26.07.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit
import RealmSwift
//import Alamofire

enum AttachmentEnum: String {
    case photo = "photo"
    case video = "video"
    case audio = "audio"
    case doc = "doc"
    case link = "link"
}

class ServiceNetwork {
    
    let session = Session.instance
    var nextFromVKNews = ""
    var offsetWall = 0
    
    
    
    func getVkMetod(path: String, queryItem: [URLQueryItem],_ callback: @escaping ( (Data) -> Void) ){
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = path
        components.queryItems = queryItem
        
        
        guard let url = components.url else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data , responce , eror in
            if let data = data{
               DispatchQueue.main.async {
                callback(data)
                }
            }
            if let eror = eror {
                
                print("Ошибка загрузки данных!!! \n \(eror)")
            }
        }
        task.resume()
        
    }
    
    
    func getFriends(_ completion: @escaping ([FriendData]) -> Void){
        //print(#function)
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.52"),
            URLQueryItem(name: "fields", value: "photo_50"),
            URLQueryItem(name: "access_token", value: session.token)
        ]
        getVkMetod(path: "/method/friends.get", queryItem: queryArray){[weak self] jsonData in
            
            do {
                let response = try JSONDecoder().decode(VKResponse<FriendData>.self, from: jsonData)
              
                    completion(response.items)
                    self?.saveFriensToRealm(response.items)
                
            } catch {
                print(error)
                completion([])
            }
        }
        
    }
    
    
    
    func getFriendsPhoto(friend: Int,_ completion: @escaping ([Foto]) -> Void){
        //print(#function)
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.52"),
            URLQueryItem(name: "count", value: "50"),
            URLQueryItem(name: "owner_id", value: "\(friend)"),
            URLQueryItem(name: "access_token", value: session.token)
        ]
        getVkMetod(path: "/method/photos.getAll", queryItem: queryArray){jsonData in
            
            do {
                
                let fotos = try JSONDecoder().decode(VKResponse<FotoData>.self, from: jsonData).items
                
                    let tmpFoto = self.convertFoto(forFriend: friend, response: fotos)
                    completion(tmpFoto)
                    self.saveFotoToRealm(tmpFoto, friendId: friend)
         
                
            } catch {
                print(error)
                completion([])
            }
            
        }
    }
    
    func getUserWall(friend: Int,_ callback: @escaping ( ([NewsOfUser]) -> Void)){
        //print(#function)
        
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.52"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "owner_id", value: "\(friend)"),
            URLQueryItem(name: "offset", value: "\(offsetWall)"),
            URLQueryItem(name: "access_token", value: session.token)
        ]
        getVkMetod(path: "/method/wall.get", queryItem: queryArray){[weak self] jsonData in
            guard let self = self else {return}
            
            do {
                
                let response = try JSONDecoder().decode(VKResponse<WallUserElement>.self, from: jsonData).items
                
                    callback(self.convertWall(response: response))
                
            } catch {
                print(error)
                callback([])
            }
            
            
            
            //            let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
            //
            //            print(json ?? "no json")
            
            
        }
        
        
        
    }
    
    func getUserNewsFeed(newQuery: Bool = false ,_ callback: @escaping ( ([NewsOfUser]) -> Void)){
        print(#function)
        
        if newQuery {
            nextFromVKNews = ""
        }
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.120"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "filters", value: "post,photo"),
            URLQueryItem(name: "start_from", value: nextFromVKNews),
            URLQueryItem(name: "access_token", value: session.token)
        ]
        getVkMetod(path: "/method/newsfeed.get", queryItem: queryArray){[weak self] jsonData in
            guard let self = self else {return}
            
            do {
                let response = try JSONDecoder().decode(VKResponse<NewsFeedElement>.self, from: jsonData)
              
                    
                    callback(self.convertNew(response: response))
                
            } catch {
                print(error)
                callback([])
            }
            
        }
        
    }
    
    func convertNew(response : VKResponse<NewsFeedElement>) -> [NewsOfUser]{
        
        var tmpNews: [NewsOfUser] = []
        var author = ""
        var avatarUrl = ""
        var attachmentFotoSizeDicUrl: String = ""
        
        let news = response.items
        guard let profiles = response.profiles,
        let group = response.groups,
        let nextFrom = response.nextFrom else {return []}
        self.nextFromVKNews = nextFrom
        
        
        news.forEach{(news) in
            let tmpGroup = group.filter{ $0.id == -news.sourceID}
            let tmpProfile = profiles.filter{ $0.id == news.sourceID}
            
           // print(tmpGroup)
            if tmpGroup.count > 0 {
                author = tmpGroup[0].name
                if let avatar = tmpGroup[0].imageUrl {
                    avatarUrl = avatar
                }
            } else {
                author = tmpProfile[0].firstName
                if let avatar = tmpProfile[0].imageUrl {
                    avatarUrl = avatar
                }
            }
            let newsDate = Date(timeIntervalSince1970: TimeInterval(news.date))
            let newsText = news.text
            let countOfViews = news.views.count
            let likesCount = news.likes.count
            if let newsAttach = news.attachments {
                
                newsAttach.forEach{(attachment) in
                    if attachment.type == AttachmentEnum.photo.rawValue{
                        
                        guard let photo = attachment.photo else {return}
                        let index = photo.sizes.count - 1
                        
                        attachmentFotoSizeDicUrl = photo.sizes[index].url ?? ""
                    }
                    if attachment.type == AttachmentEnum.video.rawValue{
                        guard let video = attachment.video else {return}
                        let index = video.image.count - 1
                        
                        attachmentFotoSizeDicUrl = video.image[index].url ?? ""
                        
                    }
                    if attachment.type == AttachmentEnum.doc.rawValue{
                        guard let doc = attachment.doc?.preview.photo.sizes else {return}
                        let index = doc.count - 1
                        
                        attachmentFotoSizeDicUrl = doc[index].src ?? ""
                        
                    }
                    if attachment.type == AttachmentEnum.link.rawValue{
                        guard let link = attachment.link?.photo.sizes else {return}
                        let index = link.count - 1
                        
                        attachmentFotoSizeDicUrl = link[index].url ?? ""
                        
                    }
                }
                
                let tmpNew: NewsOfUser = NewsOfUser(author: author,
                                                    avatarUrl: avatarUrl,
                                                    imageUrl: [attachmentFotoSizeDicUrl],
                                                    attachments: nil,
                                                    date: newsDate,
                                                    newsTest: newsText,
                                                    countOfViews: countOfViews,
                                                    countOfLike: likesCount,
                                                    isLiked: true)
                
                tmpNews.append(tmpNew)
            }
            
        }
        return tmpNews
    }
    
    func convertWall(response : [WallUserElement]) -> [NewsOfUser]{
        
        var tmpNews: [NewsOfUser] = []
        
        var attachmentFotoSizeDicUrl: [String] = []
        
        
        self.offsetWall += 10
        
        
        response.forEach{(news) in
            
            //  author = news.ownerID
            //  avatarUrl = avatar
            
            let newsDate = Date(timeIntervalSince1970: TimeInterval(news.date))
            var newsText = news.text
            let countOfViews = 0
            let likesCount = news.likes.count
            var wallAttach: [WallUserAttachment]?
            if news.copyHistory?.count ?? 0 > 0 {
                wallAttach = news.copyHistory?[0].attachments
                if let text = news.copyHistory?[0].text {
                    newsText = text
                }
            } else {
                wallAttach = news.attachments
            }
            attachmentFotoSizeDicUrl = []
            
            if let wallAttach = wallAttach {
                
                wallAttach.forEach{(attachment) in
                    
                    if attachment.type.rawValue == AttachmentEnum.photo.rawValue{
                        var photo: String? = nil
                        
                        let photo1280 =  attachment.photo?.photo1280
                        let photo807 =  attachment.photo?.photo807
                        let photo604 =  attachment.photo?.photo604
                        let photo130 =  attachment.photo?.photo130
                        let photo75 =  attachment.photo?.photo75
                        
                        if photo1280 != nil {
                            photo = photo1280
                            
                        } else if photo807 != nil {
                            photo = photo807
                            
                        } else if photo604 != nil {
                            photo = photo604
                            
                        } else if photo130 != nil {
                            photo = photo130
                            
                        } else {
                            photo = photo75
                        }
                        if let photo = photo {
                            attachmentFotoSizeDicUrl.append(photo)
                        }
                    }
                    if attachment.type.rawValue == AttachmentEnum.video.rawValue{
                        let video1280  = attachment.video?.photo1280
                        let video800  = attachment.video?.photo800
                        let video640  = attachment.video?.photo640
                        let video320  = attachment.video?.photo320
                        let video130  = attachment.video?.photo130
                        
                        var photo: String? = nil
                        
                        if video1280 != nil {
                            photo = video1280
                            
                        } else if video800 != nil {
                            photo = video800
                            
                        } else if video640 != nil {
                            photo =  video640
                            
                        } else if video320 != nil {
                            photo =  video320
                            
                        } else {
                            photo =  video130
                        }
                        
                        if let photo = photo {
                            attachmentFotoSizeDicUrl.append(photo)
                        }
                        
                        
                    }
                    if attachment.type.rawValue == AttachmentEnum.link.rawValue{
                        let link1280  = attachment.photo?.photo1280
                        
                        let link604  = attachment.photo?.photo604
                        
                        let link130  = attachment.photo?.photo130
                        
                        var photo: String? = nil
                        
                        if link1280 != nil {
                            photo = link1280
                            
                        } else if link604 != nil {
                            photo =  link604
                            
                        }  else {
                            photo =  link130
                        }
                        
                        if let photo = photo {
                            attachmentFotoSizeDicUrl.append(photo)
                        }
                        
                        
                    }
                    
                }
            }
            
            //            if attachmentFotoSizeDicUrl.count > 0 {
            //                print("картинок обнаружено \(attachmentFotoSizeDicUrl.count)")
            //            }
            let tmpNew: NewsOfUser = NewsOfUser(author: "",
                                                avatarUrl: "",
                                                imageUrl: attachmentFotoSizeDicUrl,
                                                attachments: news.attachments,
                                                date: newsDate,
                                                newsTest: newsText,
                                                countOfViews: countOfViews,
                                                countOfLike: likesCount,
                                                isLiked: true)
            
            tmpNews.append(tmpNew)
        }
        
        
        return tmpNews
    }
    
    
    func convertFoto(forFriend id: Int, response : [FotoData]) -> [Foto]{
        
        
        var attachmentFotoSizeDicUrl: [Foto] = []
        
        
        response.forEach{(foto) in
            
            var photo: String? = nil
            
            let photo2560 =  foto.photo2560
            let photo1280 =  foto.photo1280
            let photo807 =  foto.photo807
            let photo604 =  foto.photo604
            let photo130 =  foto.photo130
            let photo75 =  foto.photo75
            
            
            if photo2560 != nil {
                photo = photo2560
                
            } else if photo1280 != nil {
                photo = photo1280
                
            } else if photo807 != nil {
                photo = photo807
                
            } else if photo604 != nil {
                photo = photo604
                
            } else if photo130 != nil {
                photo = photo130
                
            } else {
                photo = photo75
            }
            if let photo = photo {
                
                let tmpFotos = Foto()
                tmpFotos.friendId = id
                tmpFotos.photosUrl = photo
                
                attachmentFotoSizeDicUrl.append(tmpFotos)
            }
        }
        

        
        return attachmentFotoSizeDicUrl
    }
    
    
    
    func getMyGroups(group: String, _ callback: @escaping ( ([GroupData]) -> Void)){
        print(#function)
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.52"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: session.token)
        ]

        
        getVkMetod(path: "/method/groups.get", queryItem: queryArray){[weak self] jsonData in
            guard let self = self else {return}
            
            do {
                
                let response = try JSONDecoder().decode(VKResponse<GroupData>.self, from: jsonData).items
                
                    callback(response)
                    self.saveGroupsToRealm(response)
                
            } catch {
                print(error)
                callback([])
            }
            
            
         }
        
        
        
    }
    
    
    
    func searchGroups( q: String, quantity: Int, _ callback: @escaping ( ([GroupData]) -> Void)){
        
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.52"),
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "count", value: String(quantity)),
            URLQueryItem(name: "access_token", value: session.token)
        ]

        getVkMetod(path: "/method/groups.search", queryItem: queryArray){jsonData in
            
               
               do {
                
                let response = try JSONDecoder().decode(VKResponse<GroupData>.self, from: jsonData).items
               
                    callback(response)
                    
                    
                
               } catch {
                   print(error)
                   callback([])
               }
   
               
           }
        
    }
    
    

    // MARK: Realm
    
    func saveFriensToRealm(_ friends: [FriendData]) {
        do{
            let realm = try Realm()
            let oldObjects = realm.objects(FriendData.self)
            try realm.write{
                realm.delete(oldObjects)
                realm.add(friends)
            }
        }catch{
            print(error)
        }
    }
    
    func saveGroupsToRealm(_ groups: [GroupData]) {
        do{
            let realm = try Realm()
            let oldObjects = realm.objects(GroupData.self)
            try realm.write{
                realm.delete(oldObjects)
                realm.add(groups)
            }
        }catch{
            print(error)
        }
    }
    
    func saveFotoToRealm(_ objects: [Foto], friendId: Int) {
        do{
            let realm = try Realm()
            let oldObjects = realm.objects(Foto.self)
                   .filter("friendId == %@", friendId)
            
            try realm.write{
                realm.delete(oldObjects)
                realm.add(objects)
            }
        }catch{
            print(error)
        }
    }
    
    
    
}
