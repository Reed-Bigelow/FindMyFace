//
//  FeedViewController.swift
//  FindMyFace
//
//  Created by Developer on 10/23/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    private let refreshControl = UIRefreshControl()
    private var posts: [Post]?
    private lazy var datasource: FeedDataSource = {
        FeedDataSource(self)
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()
    }
    
    // MARK: - Private
    private func setup() {
        // Add datasource
        collectionView.dataSource = datasource
        collectionView.delegate = self
        collectionView.registerNib(FeedItemCellView.self)
        
        // Add refresh control
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }
    
    @objc private func reloadData() {
        
        // Begin the showing reload
        refreshControl.beginRefreshing()
        
        // Get the data
        RestClientService.request(Feed.self, .feed, ["date": "\(Date().timeIntervalSince1970)"]) { _, feedItem in
            if let tableFeed = feedItem, let posts = tableFeed.posts {
                self.posts = posts
                self.datasource.refresh(with: posts)
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func compose(_ sender: Any) {
        let viewController = UIStoryboard(name: "NewPost", bundle: nil).instantiateInitialViewController()
        
        present(viewController!, animated: true)
    }
}
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.ScreenDimensions.WIDTH, height: Constants.ScreenDimensions.WIDTH + 194)
    }
}
extension FeedViewController: FeedItemCellViewDelegate {
    
    func didTapProfile(_ userId: String) {
        let vC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileView") as! ProfileViewController
        vC.setup(with: userId)
        navigationController?.pushViewController(vC, animated: true)
    }
    
    func didSelectViewComments(for post: Post) {
        let vc = UIStoryboard(name: "Comments", bundle: nil).instantiateInitialViewController() as! CommentsViewController
        vc.postId = post.id ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}
