//
//  MyGroupTableViewController.swift
//  lessson 2_1
//
//  Created by Alexander Myskin on 20.06.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit

class MyGroupTableViewController: UITableViewController , GroupCellDelegate{
    
    var myGroupList: [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()

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

    

    
}
