//
//  PhotoCollectionViewCell.swift
//  lessson 2_1
//
//  Created by Alexander Myskin on 04.07.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.isHidden = true
    }
}
