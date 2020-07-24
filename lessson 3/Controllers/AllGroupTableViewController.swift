//
//  AllGroupTableViewController.swift
//  lessson 2_1
//
//  Created by Alexander Myskin on 20.06.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit

class AllGroupTableViewController: UITableViewController, GroupCellDelegate {

    
 
    

    
    
    
    var allGroupList = Group.testGroup
                            

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
 

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allGroupList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroupCell

        cell.name.text = allGroupList[indexPath.row].name
        cell.avatarView.avatarImage = allGroupList[indexPath.row].image
        cell.delegate = self

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               allGroupList.remove(at: indexPath.row)
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

}
