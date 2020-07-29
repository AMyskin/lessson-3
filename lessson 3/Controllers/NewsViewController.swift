//
//  NewsViewController.swift
//  VKClient
//
//  Created by Vadim on 23.07.2020.
//  Copyright © 2020 Vadim. All rights reserved.
//

import UIKit

final class NewsViewController: UITableViewController {
    
    lazy var service = ServiceNetwork()
    
    var news: [NewsOfUser] = []
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        news = (1...5).map { _ in NewsOfUser.randomOne }
        //service.getUserWall()
        
        
        service.getUserNewsFeed({(news) in
            self.news = news
            DispatchQueue.main.async { // Correct
                self.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Navigation
    
    
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCell
        cell.configure(item: news[indexPath.row], dateFormatter: dateFormatter)
        
        return cell
    }
    
}
