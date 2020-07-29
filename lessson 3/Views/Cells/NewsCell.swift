//
//  NewsCell.swift
//  VKClient
//
//  Created by Vadim on 23.07.2020.
//  Copyright © 2020 Vadim. All rights reserved.
//

import UIKit
import Kingfisher

final class NewsCell: UITableViewCell {
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var countOfViewLabel: UILabel!
    @IBOutlet weak var countOfLikeLabel: UILabel!
    
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
        newsTextLabel.text = item.newsTest
        photoImageView.image = item.image[0]
        authorImageView.image = UIImage(named: "1")
        imageURL = item.imageUrl
        avatarURL = item.avatarUrl
        countOfViewLabel.text = getStringOfCount(item.countOfViews)
        countOfLikeLabel.text = getStringOfCount(item.countOfLike)
    }
    
    func getStringOfCount(_ num : Int) -> String {
        var str = ""
        
        if num > 1000 {
            str = String(format: "%.dK", num/1000)
        }else {
            str = "\(num)"
        }
        
        return str
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorNameLabel.text = nil
          publishedDateLabel.text = nil
          newsTextLabel.text = nil
          photoImageView.image = nil
          authorImageView.image = nil
          imageURL = nil
          avatarURL = nil
          countOfViewLabel.text = nil
          countOfLikeLabel.text = nil
    }
    
}
