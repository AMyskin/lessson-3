//
//  NewsCell.swift
//  VKClient
//
//  Created by Vadim on 23.07.2020.
//  Copyright © 2020 Vadim. All rights reserved.
//

import UIKit

final class NewsCell: UITableViewCell {
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorImageView?.makeCircle()
    }
    
    func configure(item: NewsOfUser, dateFormatter: DateFormatter) {
        
        authorNameLabel.text = item.author
        publishedDateLabel.text = item.userDate
        newsTextLabel.text = item.newsTest
        photoImageView.image = item.image[0]
        authorImageView.image = UIImage(named: "1")
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
}
