//
//  FriendsVC.swift
//  lessson 2_1
//
//  Created by Alexander Myskin on 24.06.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CharDelegate, CustomSearchViewDelegate {


  
    @IBOutlet weak var customSearchBar: CustomSearchView!
    
    lazy var service = ServiceNetwork()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredUsers: [User]  = []
    var filteredUsersWithSection : [Array<User>] = []
    var filteredChars: [String] = User.sectionsOfFriends
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var userList = User.arrayOfFriends
    
    var chars = User.sectionsOfFriends
    
    
    
    
    
    var isFiltering: Bool {
        
        return searchController.isActive && !isSearchBarEmpty
    }
    
    
    var char: String = ""
    
    func charPushed(char letter: String) {

        
        guard let section = filteredChars.firstIndex(of: letter) else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: section),
                              at: .top,
                              animated: false)
        
    }
    
    
    
    
    @IBOutlet weak var charPicker: CharPicker!
    @IBOutlet weak var tableView: UITableView!
    
    
//    static func storyboardInstance() -> FriendsVC? {
//             let storyboard = UIStoryboard(name: "Main", bundle: nil)
//             return storyboard.instantiateViewController(withIdentifier: "FriendsVC") as? FriendsVC
//         }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44
        
        service.getFriends()
        
        
        //service.getFriendsPhoto()
        
        
       
   
     
        //customSearchBar.delegate = self
        charPicker.delegate = self
        charPicker.chars = chars
        
        
        
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        
        searchController.searchBar.placeholder = "Поиск"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        
        setupTableView()
    }
    
    
    
   
    

    
    private func setupTableView() {
        tableView.register(UINib(nibName: "FreindsCell", bundle: nil), forCellReuseIdentifier: "Cell")
        let headerNib = UINib.init(nibName: "FriendsHeaderCell", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "FriendsHeaderCell")
    }
    
  
    

 
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFiltering {
            return filteredChars.count
        }
        
        return chars.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendsHeaderCell") as! FriendsHeaderCell
        
        
        
            
        headerView.headerTitle.text = filteredChars[section]
        
    
        
        
        let color: UIColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5)
        
        headerView.headerView.backgroundColor = color
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 40
    }
    
    

    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if isFiltering {
            return filteredUsersWithSection[section].count
        }
        
        return userList[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FreindsCell
        
        
        let user: User
        
        if isFiltering {
            user = filteredUsersWithSection[indexPath.section][indexPath.row]
        } else {
            user = userList[indexPath.section][indexPath.row]
        }
        
        
        
        cell.name.text = user.name
        cell.avatarView.avatarImage = user.avatar
        //cell.avatarButton.setImage(user.avatar, for: .normal)
        
        let animation = AnimationFactory.makeSlideIn(duration: 1, delayFactor: 0.01)
        let animator = TableAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
        
        //cell.delegate = self
        

        
        
        
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    let testVC = NewsVC.storyboardInstance()
        
        if isFiltering {
            //testVC?.userImage = filteredUsersWithSection[indexPath.section][indexPath.row].image
           // testVC?.userNews = filteredUsersWithSection[indexPath.section][indexPath.row].newsTest
            testVC?.user = filteredUsersWithSection[indexPath.section][indexPath.row]
        } else {
            //testVC?.userImage = userList[indexPath.section][indexPath.row].image
            // testVC?.userNews = userList[indexPath.section][indexPath.row].newsTest
            testVC?.user = userList[indexPath.section][indexPath.row]
        }
        navigationController?.pushViewController(testVC!, animated: true)
        
   
    }
    
    

    
    func letterPicked(_ letter: String) {
        guard let section = filteredChars.firstIndex(of: letter) else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: section),
                              at: .top,
                              animated: false)
    }
    
    

    
    func CustomSearch(chars: String) {
        
        if chars.count > 0 {
            filterContentForSearchText(chars)
                  searchController.isActive = true
                  searchController.searchBar.text = (chars)
    
        } else {
            searchController.isActive = false
            searchController.searchBar.text = nil
        }
      
    }
    
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    @IBAction func passData() {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          guard let secondViewController = storyboard.instantiateViewController(identifier: "NewsVC") as? NewsVC else { return }
       
          
          show(secondViewController, sender: nil)
      }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "userSeque" else { return }
//        guard let destination = segue.destination as? CollectionViewController else { return }
//        guard let tableSection = tableView.indexPathForSelectedRow?.section else {return}
//        guard let tableRow = tableView.indexPathForSelectedRow?.row else {return}
//
//
//
//        if isFiltering {
//            destination.userImage = filteredUsersWithSection[tableSection][tableRow].image
//        } else {
//            destination.userImage = userList[tableSection][tableRow].image
//        }
//
//    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        var allUsers: [User] = []
        for (index, _) in userList.enumerated() {
            for item in userList[index]{
                
                allUsers.append(item)
            }
            
        }
        
        
        filteredUsers = allUsers.filter { (user: User) -> Bool in
            
            return user.name.lowercased().contains(searchText.lowercased())
        }
        
        
        
        filteredUsersWithSection = []
        filteredChars = []
        
        filteredChars  =
            Array(
                Set(
                    filteredUsers.map ({
                        String($0.name.prefix(1)).uppercased()
                    })
                )
            ).sorted()
        
        var arrayOfFriends:  Array<Array<User>>
        {
            var tmp:Array<Array<User>> = []
            
            for section in filteredChars {
                let letter: String = section
                tmp.append(filteredUsers.filter { $0.name.hasPrefix(letter) })
            }
            return tmp
            
        }
        filteredUsersWithSection = arrayOfFriends
        
        if searchText == "" {
            filteredChars = User.sectionsOfFriends
        }
        
        charPicker.chars = filteredChars
        
        
        tableView.reloadData()
        
        
    }
    
    
    
    
    
    
    
}
extension FriendsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension UIView{
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
       //print(gradientLayer.frame)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}




