//
//  FriendsNetwork.swift
//  lessson 3
//
//  Created by Alexander Myskin on 26.07.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit
//import Alamofire

class ServiceNetwork {
    
    let session = Session.instance

    
    

    
    
    func getVkMetod(path: String, queryItem: [URLQueryItem],_ callback: @escaping ( (Data) -> Void) ){

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = path
        components.queryItems =
            queryItem
        
        
        guard let url = components.url else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data , responce , eror in
            if let data = data{
                
                callback(data)
         
            }
            if let eror = eror {
                
                print("Ошибка загрузки данных!!! \n \(eror)")
            }
        }
        task.resume()
       
    }
    
    
    func getFriends(){
        print(#function)
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.52"),
            URLQueryItem(name: "fields", value: "photo_50"),
            URLQueryItem(name: "access_token", value: session.token)
        ]
        getVkMetod(path: "/method/friends.get", queryItem: queryArray){[weak self] jsonData in
            
            guard let self = self else {return}
            
             //let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
            
            self.parseUserJSON(withDate: jsonData)
            
             //print(json ?? "no json")
          
            
        }
      
        print("--------------------\n")
        

    }
    
    

       func getFriendsPhoto(){
        print(#function)
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.52"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "access_token", value: session.token)
        ]
        getVkMetod(path: "/method/photos.getAll", queryItem: queryArray){jsonData in
            
            
             let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
            
             print(json ?? "no json")
          
            
        }
        
        print("--------------------\n")
        
       }
    
    func getUserWall(){
     print(#function)
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.52"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "access_token", value: session.token)
        ]
     getVkMetod(path: "/method/wall.get", queryItem: queryArray){jsonData in
         
         
          let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
         
          print(json ?? "no json")
       
         
     }
     
     print("--------------------\n")
     
    }
    
    func getUserNewsFeed(_ callback: @escaping ( ([NewsOfUser]) -> Void)){
     print(#function)
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.120"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "filters", value: "post,photo"),
            URLQueryItem(name: "access_token", value: session.token)
        ]
     getVkMetod(path: "/method/newsfeed.get", queryItem: queryArray){jsonData in
         
         
        guard let news = self.parseNewsJSON(withDate: jsonData) else {return}
        callback(news)
        
          //let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
         
          //print(json ?? "no json")
       
         
     }
     
     print("--------------------\n")
     
    }
    
    
    func getMyGroups(group: String, _ callback: @escaping ( ([Group]) -> Void)){
        print(#function)
            let queryArray: [URLQueryItem] = [
                URLQueryItem(name: "v", value: "5.52"),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "access_token", value: session.token)
            ]
         getVkMetod(path: "/method/groups.get", queryItem: queryArray){jsonData in
            
            guard let myGroup = self.parseGroupJSON(withDate: jsonData) else {return}
            callback(myGroup)
                       
    
             
             //let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
             
             // print(json ?? "no json")
           
             
         }
         
         print("--------------------\n")
        
           
           
       }
    

    
   
    func searchGroups( q: String, quantity: Int){
        print(#function)
             let queryArray: [URLQueryItem] = [
                 URLQueryItem(name: "v", value: "5.52"),
                 URLQueryItem(name: "q", value: q),
                 URLQueryItem(name: "count", value: String(quantity)),
                 URLQueryItem(name: "access_token", value: session.token)
             ]
          getVkMetod(path: "/method/groups.search", queryItem: queryArray){jsonData in
              
              
               let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
              
               print(json ?? "no json")
            
              
          }
          
          
           
       }
    
    
    func parseGroupJSON(withDate data: Data) -> [Group]?{
         
        var tmpGroups: [Group] = []
         let json = try? JSONSerialization.jsonObject(with: data, options: [])
             if let dictionary = json as? [String: Any] {

                 if let response = dictionary["response"] as? NSDictionary {

                     if let items = response["items"] as? NSArray {
                         for item in items {
                             
                             let testUser = item as! NSDictionary
                             
                            guard  let name = testUser["name"] as? String,
                                let screenName = testUser["screen_name"] as? String,
                                let photo50 = testUser["photo_50"] as? String
  
                                else {return nil}
                            
                            
                            
                            let tmpGroup: Group = Group(name: name, image: UIImage(named: "1")!, imageUrl: photo50)
                             print ("\(name) \(screenName)")
                            
                            tmpGroups.append(tmpGroup)
                 
                         }
                         
                     }
                 }
             }
         
          
             
          return tmpGroups
     
     }
    
    func parseNewsJSON(withDate data: Data) -> [NewsOfUser]?{
           
        var tmpNews: [NewsOfUser] = []
        var tmpGroup: [Group] = []
        var tmpProfiles: [Profiles] = []
        var date: Date?
        var attachmentFotoSizeDicUrl: String?
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dictionary = json as? [String: Any] {

                   if let response = dictionary["response"] as? NSDictionary {
                    
                    guard  let groups = response["groups"] as? NSArray else {return nil}
                    for item in groups {
                        
                        guard
                        let item = item as? NSDictionary,
                        let id = item["id"] as? Int,
                        let avatar = item["photo_50"] as? String,
                        let name = item["name"] as? String
                        else {return nil}
                        let group: Group = Group(id: id, name: name, image: UIImage(named: "1")!, imageUrl: avatar)
                        tmpGroup.append(group)
                    }
                    
                    guard  let profiles = response["profiles"] as? NSArray else {return nil}
                    for item in profiles {
                        
                        guard
                        let item = item as? NSDictionary,
                        let id = item["id"] as? Int,
                        let avatar = item["photo_50"] as? String,
                        let firstName = item["first_name"] as? String,
                        let lastName = item["last_name"] as? String
                        
                        else {return nil}
                        let profiles = Profiles(id: id, firstName: firstName, lastName: lastName, imageUrl: avatar)
                        tmpProfiles.append(profiles)
                    }

                       if let items = response["items"] as? NSArray {
                           for item in items {
                               
                               
                               
                            guard
                                let testNews = item as? NSDictionary,
                                let sourceId = testNews["source_id"] as? Int,
                                let views = testNews["views"] as? NSDictionary,
                                let viewsCount = views["count"] as? Int,
                                let text = testNews["text"] as? String,
                                let likes = testNews["likes"] as? NSDictionary,
                                let likesCount = likes["count"] as? Int,
                                let attachments = testNews["attachments"] as? NSArray,
                                let attachmentsDic = attachments[0] as? NSDictionary
                                else {
                                    print("чего то нет")
                                    return nil}
                            if let newsDate = testNews["date"] as? Int {
                                date = Date(timeIntervalSince1970: TimeInterval(newsDate))
                            }
                            guard let dateNews = date else {return nil}
                            
                            var author = ""
                            var avatarUrl = ""
                            
                            tmpGroup.forEach{(groups) in
                                
                                if (-sourceId) == groups.id {
                                    print(groups.name)
                                    author = groups.name
                                    if let avatar = groups.imageUrl {
                                        avatarUrl = avatar
                                    }
                                }
                                
                            }
                            tmpProfiles.forEach{(profiles) in
                                      
                                      if (sourceId) == profiles.id {
                                          print(profiles.firstName)
                                          author = profiles.firstName
                                          if let avatar = profiles.imageUrl {
                                              avatarUrl = avatar
                                          }
                                      }
                                      
                                  }
                            

                            
                            
                            if  let attachmentFoto = attachmentsDic["photo"] as? NSDictionary {
                                
                                guard let attachmentFotoSize = attachmentFoto["sizes"] as? NSArray else {return nil}
                                let index = attachmentFotoSize.count-1
                                let attachmentFotoSizeDic = attachmentFotoSize[index] as? NSDictionary
                                attachmentFotoSizeDicUrl = attachmentFotoSizeDic?["url"] as? String
                            } else if let attachmentVideo = attachmentsDic["video"] as? NSDictionary,
                                let attachmentVideoSize = attachmentVideo["image"] as? NSArray{
                              
                                let index = attachmentVideoSize.count-1
                                let attachmentVideoSizeDic = attachmentVideoSize[index] as? NSDictionary
                                attachmentFotoSizeDicUrl = attachmentVideoSizeDic?["url"] as? String
                                
                            }else if let attachmentDoc = attachmentsDic["doc"] as? NSDictionary {
                                print("doc")
                            }
                            
                            
                              
                              
                              
                              
                             let tmpNew: NewsOfUser = NewsOfUser(author: author,
                                                                 avatarUrl: avatarUrl,
                                                                 image: [UIImage(named: "1")!],
                                                                 imageUrl: attachmentFotoSizeDicUrl,
                                                                 userDate: "1.1.2020",
                                                                 date: dateNews,
                                                                 newsTest: text,
                                                                 countOfViews: viewsCount,
                                                                 countOfLike: likesCount,
                                                                 isLiked: true)
                               print ("\(text) \(likesCount) \(viewsCount)")
                              
                              tmpNews.append(tmpNew)
                   
                           }
                           
                       }
                   }
               }
           
            
               
            return tmpNews
       
       }
    
    
    
    
    
    
    
    func parseUserJSON(withDate data: Data){
        
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dictionary = json as? [String: Any] {

            if let nestedDictionary = dictionary["response"] as? NSDictionary {

                if let items = nestedDictionary["items"] as? NSArray {
                    for item in items {
                        
                        let testUser = item as! NSDictionary
                        guard  let userFirstName = testUser["first_name"],
                                let userLastName = testUser["last_name"]else {return}
                        print ("\(userFirstName) \(userLastName)")
            
                    }
                    
                }
            }
        }
    
    }
    
}
