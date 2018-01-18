//
//  UsersPhotosResultsViewController.swift
//  FindMyFace
//
//  Created by Developer on 12/3/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import ObjectMapper
import SVProgressHUD

class UsersPhotosResultsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var posts: [Post]?
    private var users: [Profile]?
    lazy var dataSource: UsersPhotosResultsViewControllerDataSource = {
        UsersPhotosResultsViewControllerDataSource(self)
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Public
    func setup(_ item: Any) {
        SVProgressHUD.show()
        
        switch item {
        case let users as [Profile]:
            self.users = users
            downloadPosts()
        case let image as UIImage:
            searchImage(with: image)
        default:
            return
        }
        
        downloadPosts()
    }
    
    // MARK: - Private
    private func searchImage(with image: UIImage) {
        let fixedImage = image.fixedOrientation()
        RestClientService.uploadData(with: fixedImage, .relatedPosts) { _, rawJson in
            if let usersJson = rawJson?["users_found"] as? [[String: Any]] {
                self.users = Mapper<Profile>().mapArray(JSONArray: usersJson)
                self.downloadPosts()
            } else {
                SVProgressHUD.showError(withStatus: "No Posts Found")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func reload() {
        guard let posts = posts, let users = users else {
            return
        }
        
        collectionView.dataSource = dataSource

        dataSource.refresh(with: posts, users)
        collectionView.reloadData()
        
        SVProgressHUD.dismiss()
    }
    
    private func downloadPosts() {
        if let users = users {
            let userIds = users.map { $0.id ?? "" }
            let parameters = ["user_ids": userIds]
            
            RestClientService.request(.relatedPosts, nil, parameters, .post, completion: { _, rawJson in
                if (rawJson?["success"] as? Bool) == true, let json = rawJson?["posts"] as? [[String: Any]] {
                    let posts = Mapper<Post>().mapArray(JSONArray: json)
                    self.posts = posts
    
                    self.reload()
                } else {
                    SVProgressHUD.showError(withStatus: "No Posts Found")
                    self.navigationController?.popViewController(animated: true)
                }
            })
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
extension UsersPhotosResultsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (Constants.ScreenDimensions.WIDTH / 3) - 1
        return CGSize(width: size, height: size)
    }
}
extension UsersPhotosResultsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let post = posts?[indexPath.row] {
            let vc = UIStoryboard(name: "PostDetail", bundle: nil).instantiateInitialViewController() as! PostDetailViewController
            navigationController?.pushViewController(vc, animated: true)
            vc.setup(with: post)
        }
    }
}
