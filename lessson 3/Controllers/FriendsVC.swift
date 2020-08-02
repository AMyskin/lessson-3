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
    var friends: [FriendData] = []
    var friendsWithSection : [Array<FriendData>] = []
    var filteredUsers: [FriendData]  = []
    var filteredUsersWithSection : [Array<FriendData>] = []
    var filteredChars: [String] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
  //  var userList = User.arrayOfFriends
    
  //  var chars = User.sectionsOfFriends
    
    
    
    
    
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
    
    
    func sectionsOfFriends(friends: [FriendData]) -> Array<String>{
        return      Array(
            Set(
                friends.compactMap ({
                    var tmp : String?
                    if String($0.lastName.prefix(1)).uppercased() != "" {
                        tmp = String($0.lastName.prefix(1)).uppercased()
                    } else {
                        tmp = nil
                    }
                    return tmp
                })
            )
        ).sorted()
    }
    
    func arrayOfFriends(sections: Array<String> , friens: [FriendData]) ->Array<Array<FriendData>> {
        var tmp:Array<Array<FriendData>> = []
        for section in sections {
            let letter: String = section
            tmp.append(friens.filter { $0.lastName.hasPrefix(letter) && letter != ""})
        }
        return tmp
    }
    
    

       

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44
        
        
        
        service.getFriends({[weak self] (friends) in
            guard let self = self else {return}
            self.friends = friends
            self.filteredChars = self.sectionsOfFriends(friends: friends)
            self.friendsWithSection = self.arrayOfFriends(sections: self.filteredChars , friens: friends)

           // print(self.filteredChars)
            DispatchQueue.main.async { // Correct
                self.tableView.reloadData()
                self.charPicker.delegate = self
                self.charPicker.chars =  self.filteredChars
                
            }
        })
        
        
        //service.getFriendsPhoto()
        
        
       
   
     
        //customSearchBar.delegate = self
        //charPicker.delegate = self
        //charPicker.chars = filteredChars
        
        
        
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
        
//        if isFiltering {
//            return filteredChars.count
//        }
        
        return filteredChars.count
        
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
        
        return friendsWithSection[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FreindsCell
        
        
        let user: FriendData
        
        if isFiltering {
            user = filteredUsersWithSection[indexPath.section][indexPath.row]
        } else {
            user = friendsWithSection[indexPath.section][indexPath.row]
        }
        
        
        cell.configure(friend: user)
       // cell.name.text = "\(user.firstName) \(user.lastName)"
        //cell.avatarView.avatarImage = user.avatar
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
            testVC?.friend = filteredUsersWithSection[indexPath.section][indexPath.row]
        } else {
            //testVC?.userImage = userList[indexPath.section][indexPath.row].image
            // testVC?.userNews = userList[indexPath.section][indexPath.row].newsTest
            testVC?.friend = friendsWithSection[indexPath.section][indexPath.row]
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
        
        var allUsers: [FriendData] = []
        for (index, _) in friendsWithSection.enumerated() {
            for item in friendsWithSection[index]{
                
                allUsers.append(item)
            }
            
        }
        
        
        filteredUsers = allUsers.filter { (user: FriendData) -> Bool in
            
            return user.lastName.lowercased().contains(searchText.lowercased()) || user.firstName   .lowercased().contains(searchText.lowercased())
        }
        
        
        
        filteredUsersWithSection = []
        filteredChars = []
        
        filteredChars  =
            Array(
                Set(
                    filteredUsers.map ({
                        String($0.lastName.prefix(1)).uppercased()
                    })
                )
            ).sorted()
        
        var arrayOfFriends:  Array<Array<FriendData>>
        {
            var tmp:Array<Array<FriendData>> = []
            
            for section in filteredChars {
                let letter: String = section
                tmp.append(filteredUsers.filter { $0.lastName.hasPrefix(letter) })
            }
            return tmp
            
        }
        filteredUsersWithSection = arrayOfFriends
        
        if searchText == "" {
            filteredChars = self.sectionsOfFriends(friends: friends)
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




