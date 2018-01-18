//
//  ProfileViewController.swift
//  FindMyFace
//
//  Created by Developer on 10/31/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import ObjectMapper

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private lazy var dataSource: ProfileCollectionDataSource = {
        ProfileCollectionDataSource(self)
    }()
    private var profile: Profile?
    private var userId: String?
    private var usersPosts: [Post]?
    private var bookmarkPosts: [Post]?
    private var taggedPosts: [Post]?
    private var currentPosts: [Post]?
    private var currentSelectedScreen: ProfileSubview = .userPosts
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadProfile()
    }
    
    // MARK: - Public
    func setup(with userId: String) {
        self.userId = userId
    }
    
    // MARK: - Private
    private func downloadProfile() {
        if userId == nil {
            userId = UserDefaults.value(forKey: .id) as? String
        }
        
        RestClientService.request(.user, ["user_id": userId ?? ""], nil, .get) { _, rawJson in
            if let json = rawJson?["user_info"] as? [String: Any] {
                let profile = Mapper<Profile>().map(JSON: json)
                self.profile = profile
                self.reloadData()
            }
        }
        
        downloadPosts(for: .userPosts)
    }
    
    private func reloadData() {
        guard let profile = profile, let usersPosts = currentPosts else {
            return
        }
        
        navigationItem.title = profile.username
        dataSource.reload(withProfilePosts: profile, usersPosts, currentSelectedScreen)
        collectionView.reloadData()
    }
    
    private func downloadPosts(for type: ProfileSubview) {
        var downloadType: RestClientService.RequestEndpoint = .userPosts
        
        switch type {
        case .userTagged:
            downloadType = .userTaggedPosts
        case .userPosts:
            downloadType = .userPosts
        case .userPostsFeed:
            downloadType = .userPosts
        case .bookmarked:
            downloadType = .userBookmarks
        }
        
        RestClientService.request(Feed.self, downloadType, ["user_id": userId ?? ""]) { _, feed in
            guard let feed = feed, let posts = feed.posts else {
                return
            }
            
            self.currentPosts = posts
            self.reloadData()
        }
    }
    
    private func moveCollectionView(to view: ProfileSubview) {
        switch view {
        case .userTagged:
            if taggedPosts == nil {
                downloadPosts(for: .userTagged)
            } else {
                currentPosts = taggedPosts
            }
            
            currentSelectedScreen = .userTagged
        case .userPosts:
            if usersPosts == nil {
                downloadPosts(for: .userPosts)
            } else {
                currentPosts = usersPosts
            }
            
            currentSelectedScreen = .userPosts
        case .bookmarked:
            if bookmarkPosts == nil {
                downloadPosts(for: .bookmarked)
            } else {
                currentPosts = usersPosts
            }
            
            currentSelectedScreen = .bookmarked
        default:
            print("Add this")
        }
    }
    
    // MARK: - Actions
    @IBAction func refreshButton(_ sender: Any) {
        downloadProfile()
    }
}
extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "PostDetail", bundle: nil).instantiateInitialViewController() as! PostDetailViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.setup(with: (currentPosts![indexPath.item]))
    }
}
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (Constants.ScreenDimensions.WIDTH / 3) - 1
        return CGSize(width: size, height: size)
    }
}
extension ProfileViewController: ProfileSummaryReusableViewDelegate {
    
    func didSelect(_ view: ProfileSubview) {
        moveCollectionView(to: view)
    }
}
