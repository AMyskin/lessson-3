//
//  PhotosViewController.swift
//  VKClient
//
//  Created by Vadim on 23.07.2020.
//  Copyright © 2020 Vadim. All rights reserved.
//

import UIKit

final class PhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    lazy var service = ServiceNetwork()
    var photos: [UIImage] = []
    var photosUrl: [String] = []
    var userId: Int = 0
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.getFriendsPhoto(friend: userId){[weak self] (fotos) in
            guard let self = self else {return}
            
            self.photosUrl = fotos
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let controller = segue.destination as? SliderViewController,
            let indexPath = collectionView.indexPathsForSelectedItems?.first
        {
            controller.title = title
            controller.photos = photos
            controller.photosUrl = photosUrl
            controller.currentIndex = indexPath.row
        }
    }
    
    // MARK: - UICollectionViewDataSource & UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosUrl.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
        cell.imageURL = photosUrl[indexPath.row]
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    enum Layout {
        static let columns: CGFloat = 3
        static let spacing: CGFloat = 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - Layout.spacing * (Layout.columns - 1)) / Layout.columns
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.spacing
    }
    
    static func storyboardInstance() -> PhotosViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController
    }
    
}
