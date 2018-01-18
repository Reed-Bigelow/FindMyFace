//
//  PostDetailViewController.swift
//  FindMyFace
//
//  Created by Developer on 11/1/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var post: Post?
    private lazy var dataSource: PostDetailDataSource = {
        PostDetailDataSource(self)
    }()
    
    // MARK: - Lifecycle
    func setup(with post: Post) {
        self.post = post
        dataSource.refresh(with: post)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    // MARK: - Private
    private func reload() {
        collectionView.registerNib(FeedItemCellView.self)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
}
extension PostDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.ScreenDimensions.WIDTH, height: Constants.ScreenDimensions.WIDTH + 194)
    }
}
extension PostDetailViewController: FeedItemCellViewDelegate {
    
    func didTapProfile(_ userId: String) {
        let vC = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as? ProfileViewController
        vC?.setup(with: userId)
        navigationController?.pushViewController(vC!, animated: true)
    }
    
    func didSelectViewComments(for post: Post) {
        let vc = UIStoryboard(name: "Comments", bundle: nil).instantiateInitialViewController() as! CommentsViewController
        vc.postId = post.id ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}
