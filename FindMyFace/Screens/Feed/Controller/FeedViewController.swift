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
    private lazy var datasource: FeedDataSource = {
        FeedDataSource()
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Private
    private func setup() {
        // Add datasource
        collectionView.dataSource = datasource
        collectionView.delegate = self
        
        // Add refresh control
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        // Reload the data
        reloadData()
    }
    
    @objc private func reloadData() {
        
        // Begin the showing reload
        refreshControl.beginRefreshing()
        
        // Get the data
        RestClientService.request(Feed.self, ["date": Date().utcString()]) { _, feedItem in
            if let tableFeed = feedItem as? Feed, let posts = tableFeed.posts {
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
        return CGSize(width: Constants.ScreenDimensions.WIDTH - 20, height: Constants.ScreenDimensions.WIDTH + 80)
    }
}
