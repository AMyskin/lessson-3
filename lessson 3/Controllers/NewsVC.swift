//
//  NewsVC.swift
//  lessson 2_1
//
//  Created by Alexander Myskin on 01.07.2020.
//  Copyright © 2020 Alexander Myskin. All rights reserved.
//

import UIKit

class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NewsDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    
    
    
    
    var selectedCell = UICollectionViewCell()
    
    
    let transitionController = TransitionController()
    
    
    var user : User!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    static func storyboardInstance() -> NewsVC? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = storyboard.instantiateViewController(withIdentifier: "NewsVC") as? NewsVC
        
        return cell
    }
    
    private func setupTableView() {
        
        
        
        tableView.register(UINib(nibName: "UserNewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        tableView.allowsSelection = false
        
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        user.newsTest.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
        guard let cell = cell as? UserNewsCell else {return}
        cell.setCollectionDelegate(self, for: indexPath.row)
        
        
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! UserNewsCell
        
        let news = user.newsTest[indexPath.row]
        //news.author = user.name
        //news.avatar = user.avatar
        
        
        
        cell.configure(model: news)
        
        
        
        
        cell.delegate = self
        
        
        
        return cell
    }
    
    
    //
    
    
    
    
    func buttonTapped(cell: UserNewsCell, button: UIButton){
        
        
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.8
        pulse.toValue = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1
        
        button.layer.add(pulse, forKey: nil)
        
        print("\(button) tapped on row \(indexPath.row) new countOfLike = \(user.newsTest[indexPath.row].countOfLike)")
        
        showErrorAlert()
        
        
    }
    
    
    
    
    
    func buttonTappedLike(cell: UserNewsCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        
        
        
        user.newsTest[indexPath.row].isLiked.toggle()
        
        let likesCount = user.newsTest[indexPath.row].countOfLike
        
        user.newsTest[indexPath.row].countOfLike = user.newsTest[indexPath.row].isLiked ? likesCount + 1 : likesCount - 1
        
        print("Like tapped on row \(indexPath.row) new countOfLike = \(user.newsTest[indexPath.row].countOfLike)")
        
        
    }
    
    
    
    func errorFunc() {
        //print(#function)
        showErrorAlert()
    }
    func likeNews(isLiked: Bool) {
        //print("like \(isLiked)")
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: "Under Conctruction",
            message: "Данный функционал в разработке",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Collection view data source
    
    enum Constants {
        static let maxPhotos = 4
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCollectionViewCell else {return}
        
        cell.alpha = 1
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        animation.beginTime = CACurrentMediaTime() + 0.1 * Double(indexPath.row)
        cell.layer.add(animation, forKey: nil)
        
        let fromValue = CGRect(x: cell.layer.bounds.origin.x, y: cell.layer.bounds.origin.y,   width: cell.layer.bounds.width/3, height: cell.layer.bounds.height/3)
        let toValue = CGRect(x: cell.layer.bounds.origin.x, y: cell.layer.bounds.origin.y,   width: cell.layer.bounds.width, height: cell.layer.bounds.height)
        
        let animation2 = CABasicAnimation(keyPath: "bounds")
        animation2.fromValue = fromValue
        animation2.toValue = toValue
        animation2.duration = 0.5
        cell.layer.add(animation2, forKey: nil)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imagesCount = user.newsTest[collectionView.tag].image.count
        return imagesCount > Constants.maxPhotos ? Constants.maxPhotos : imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        
        let newsModel = user.newsTest[collectionView.tag]
        let image = user.newsTest[collectionView.tag].image[indexPath.row]
        
        cell.photoImageView.image = image
        
        if indexPath.row == Constants.maxPhotos - 1 {
            let count = newsModel.image.count - Constants.maxPhotos
            cell.countLabel.text = "+\(count)"
            cell.containerView.isHidden = count == 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width / 2,
            height: collectionView.bounds.height / 2
        )
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //       let collectionPhotoVC = CollectionViewController.storyboardInstance()
        //
        //        collectionPhotoVC?.userImage = user.newsTest[collectionView.tag].image
        //        navigationController?.pushViewController(collectionPhotoVC!, animated: true)
        
        
        
        guard  let collectionPhotoVC = SwipeVC.storyboardInstance(),
            let selectedcell2 = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell
            else {return}
        collectionPhotoVC.transitioningDelegate = self
        
        
        
        collectionPhotoVC.userImage = user.newsTest[collectionView.tag].image
        
        selectedCell = selectedcell2
        
        
        
        collectionPhotoVC.indexOfImage = indexPath.row
        //        navigationController?.pushViewController(collectionPhotoVC!, animated: true)
        //
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let secondViewController = storyboard.instantiateViewController(identifier: "SwipeVC")
        collectionPhotoVC.modalPresentationStyle = .fullScreen
        
        
        collectionPhotoVC.transitioningDelegate = transitionController
        transitionController.startView = selectedcell2.photoImageView
        
        self.present(collectionPhotoVC, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
}



extension NewsVC: UIViewControllerTransitioningDelegate {
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            
            return PopAnimator(startImage: selectedCell, presenting: true, interactionController: nil)
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            guard let swipeVC = dismissed as? SwipeVC else {
                return nil}
            
            return PopAnimator(startImage: selectedCell, presenting: false,interactionController: swipeVC.swipeInteractionController)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?{
        guard let animator = animator as? PopAnimator,
            let interactionController = animator.interactionController,
            interactionController.interactionInProgress
            else {
                return nil
        }
        return interactionController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            guard let animator = animator as? PopAnimator,
                let interactionController = animator.interactionController,
                interactionController.interactionInProgress
                else {
                    return nil
            }
            return interactionController
    }
    
    
}

