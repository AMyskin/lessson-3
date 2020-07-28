//
//  FriendsNetwork.swift
//  lessson 3
//
//  Created by Alexander Myskin on 26.07.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit

class ServiceNetwork {
    
    let session = Session.instance
    var userList: [Array<User>] = []
    
    func getUserList() -> [Array<User>]{
        return userList
    }
    
    
    func getVkMetod(path: String, queryItem: [URLQueryItem] ){

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

                let json = try? JSONSerialization.jsonObject(with: data, options: [])
 
                 print(json ?? "no json")
                
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
        getVkMetod(path: "/method/friends.get", queryItem: queryArray)
        
        print("--------------------\n")
        

    }
    
    

       func getFriendsPhoto(){
        print(#function)
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.52"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "access_token", value: session.token)
        ]
        getVkMetod(path: "/method/photos.getAll", queryItem: queryArray)
        
        print("--------------------\n")
        
       }
    
    func getUserWall(){
     print(#function)
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.52"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "access_token", value: session.token)
        ]
     getVkMetod(path: "/method/wall.get", queryItem: queryArray)
     
     print("--------------------\n")
     
    }
    
    func getUserNewsFeed(){
     print(#function)
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.120"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "filters", value: "post,photo"),
            URLQueryItem(name: "access_token", value: session.token)
        ]
     getVkMetod(path: "/method/newsfeed.get", queryItem: queryArray)
     
     print("--------------------\n")
     
    }
    
    
    func getMyGroups(){
        print(#function)
            let queryArray: [URLQueryItem] = [
                URLQueryItem(name: "v", value: "5.52"),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "access_token", value: session.token)
            ]
         getVkMetod(path: "/method/groups.get", queryItem: queryArray)
         
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
          getVkMetod(path: "/method/groups.search", queryItem: queryArray)
          
          
           
       }
    
    
    
    
    
    
    
    
    
    
    func parseUserJSON(withDate data: Data)-> Array<User>?{
        
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dictionary = json as? [String: Any] {

            if let nestedDictionary = dictionary["response"] as? NSDictionary {
                // access nested dictionary values by key
                if let items = nestedDictionary["items"] as? NSArray {
                    for item in items {
                        
                        let testUser = item as! NSDictionary
                        guard  let userFirstName = testUser["first_name"],
                                let userLastName = testUser["last_name"]else {return nil}
                        print ("\(userFirstName) \(userLastName)")
                       // let tempUser: Array<User> = [User(name: "\(userFirstName) \(userLastName)", image: [UIImage(named: "1")!], newsTest: [NewsOfUser.randomOne])]
                        //userList.append(tempUser)
                       // return tempUser
                    }
                    
                }
            }
        }
     return nil
    }
    
}
