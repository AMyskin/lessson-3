//
//  MyGroupTableViewController.swift
//  lessson 2_1
//
//  Created by Alexander Myskin on 20.06.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit

class MyGroupTableViewController: UITableViewController , GroupCellDelegate{
    
    let session = Session.instance
    
    
    //https://api.vk.com/method/groups.get?v=5.52&access_token=b88601f18930b149e676dacfa32b44f5552c929841d4030ad73362e012c741caa5b9bda6fc5b38fde8314&extended=1
    
    //https://api.vk.com/method/groups.search?v=5.52&access_token=b88601f18930b149e676dacfa32b44f5552c929841d4030ad73362e012c741caa5b9bda6fc5b38fde8314&q=music&count=50
    
    var myGroupList: [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 60
        
        getMyGroups()
        searchGroups( q: "music", quantity: 50)

    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
         guard
             let allGroupsController = segue.source as? AllGroupTableViewController,
             let indexPath = allGroupsController.tableView.indexPathForSelectedRow
             else { return }
         
         let group = allGroupsController.allGroupList[indexPath.row]
         
        guard !myGroupList.contains(group) else { return }
         
         myGroupList.append(group)
         tableView.reloadData()
     }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myGroupList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupCell

        cell.name.text = myGroupList[indexPath.row].name
        cell.avatarView.avatarImage = myGroupList[indexPath.row].image
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             myGroupList.remove(at: indexPath.row)
             tableView.deleteRows(at: [indexPath], with: .fade)
         }
     }
    
    func buttonTapped(cell: GroupCell, button: UIButton) {
        //guard let indexPath = self.tableView.indexPath(for: cell) else {return}
         
             
                       let pulse = CASpringAnimation(keyPath: "transform.scale")
                       pulse.duration = 0.6
                       pulse.fromValue = 0.8
                       pulse.toValue = 1
                       pulse.initialVelocity = 0.5
                       pulse.damping = 1
                       
                       button.layer.add(pulse, forKey: nil)
              
           
    }
    
       func getMyGroups(){
           let urlString =  "https://api.vk.com/method/groups.get?v=5.52&access_token=\(session.token)&extended=1"
           guard let url = URL(string: urlString) else {return}
           let session = URLSession(configuration: .default)
           let task = session.dataTask(with: url) { data , responce , eror in
               if let data = data{
                   
                   //let dataString =  String(data: data, encoding: .utf8)
                 _ = self.parseGroupJSON(withDate: data)
    
                  // print(dataString)
                   
               }
               if let eror = eror {
             
                   print("Ошибка загрузки данных!!! \n \(eror)")
               }
           }
           task.resume()
           
       }
    
    func parseGroupJSON(withDate data: Data){
        
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dictionary = json as? [String: Any] {

            if let nestedDictionary = dictionary["response"] as? NSDictionary {
                // access nested dictionary values by key
                if let items = nestedDictionary["items"] as? NSArray {
                    for item in items {
                        
                        let testUser = item as! NSDictionary
                        guard  let name = testUser["name"],
                                let screenName = testUser["screen_name"]else {return}
                        print ("\(name) \(screenName)")
                    }
                    
                }
            }
        }
        
        print ("\n")
        print ("-----------------------------------------------------")
        print ("\n")
     
    }
    
    func searchGroups( q: String, quantity: Int){
           let urlString =  "https://api.vk.com/method/groups.search?v=5.52&access_token=\(session.token)&q=\(q)&count=\(quantity)"
           guard let url = URL(string: urlString) else {return}
           let session = URLSession(configuration: .default)
           let task = session.dataTask(with: url) { data , responce , eror in
               if let data = data{
                
                _ = self.parseGroupJSON(withDate: data)
                   
                   //let dataString =  String(data: data, encoding: .utf8)
                  // let user = self.parseJSON(withDate: data)
    
                   //print(dataString)
                   
               }
               if let eror = eror {
             
                   print("Ошибка загрузки данных!!! \n \(eror)")
               }
           }
           task.resume()
           
       }

    

    
}
