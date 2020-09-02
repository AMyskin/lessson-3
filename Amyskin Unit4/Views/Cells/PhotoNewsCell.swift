//
//  PhotoNewsCell.swift
//  lessson 3
//
//  Created by Alexander Myskin on 01.09.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit
import Kingfisher

final class PhotoNewsCell: UITableViewCell {
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    var imageURL: String? {
        didSet{
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                photoImageView.kf.setImage(with: url)
            } else {
                photoImageView.image = nil
                photoImageView.kf.cancelDownloadTask()
            }
        }
    }
    var avatarURL: String? {
          didSet{
              if let avatarURL = avatarURL, let url = URL(string: avatarURL) {
                  authorImageView.kf.setImage(with: url)
              } else {
                  authorImageView.image = nil
                  authorImageView.kf.cancelDownloadTask()
              }
          }
      }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorImageView?.makeCircle()
    }
    
    func configure(item: NewsOfUser, dateFormatter: DateFormatter) {
        
        authorNameLabel.text = item.author
        publishedDateLabel.text = dateFormatter.string(from: item.date)
        imageURL = item.imageUrl?[0]
        avatarURL = item.avatarUrl

    }
    
}
