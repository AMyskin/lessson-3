//
//  FriendsNetwork.swift
//  lessson 3
//
//  Created by Alexander Myskin on 26.07.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit
import Alamofire

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
    
    func getUserNewsFeed(){
     print(#function)
        let queryArray: [URLQueryItem] = [
            URLQueryItem(name: "v", value: "5.120"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "filters", value: "post,photo"),
            URLQueryItem(name: "access_token", value: session.token)
        ]
     getVkMetod(path: "/method/newsfeed.get", queryItem: queryArray){jsonData in
         
         
          let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
         
          print(json ?? "no json")
       
         
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
    
    func getMyGroupsAlamofire(){
        
        let urlPath = "https://api.vk.com/method/groups.get?v=5.52&extended=1&access_token=b42ca51ccd59af0b509edce97b8ec5565327aed71f420ea239cd8340e0f31e276c8289f331a817622453f"
        AF.request(urlPath).responseJSON{ (responce) in
            print(responce.value ?? "no json")
            
        }
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
