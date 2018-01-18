//
//  SearchViewController.swift
//  FindMyFace
//
//  Created by Developer on 11/29/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchViewController: UIViewController {
    
    enum Table {
        case selectedTable
        case returnedTable
    }

    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var returnedUsersTableView: UITableView!
    @IBOutlet weak var returnedTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var submitButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var selectedSearchPhoto: UIImage?
    private var selectedUsers = [Profile]()
    private var returnedUsers: [Profile]?
    private var imageSearchViewController: ImageSearchViewController?
    lazy var userSelectedDataSource: UserSearchCollectionDataSource = {
        UserSearchCollectionDataSource(self)
    }()
    lazy var userReturnedDataSource: UserSearchDataSource = {
        UserSearchDataSource()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Private
    private func setup() {
        searchBar.delegate = self
        returnedUsersTableView.delegate = self
        userCollectionView.dataSource = userSelectedDataSource
        returnedUsersTableView.dataSource = userReturnedDataSource
        returnedUsersTableView.tableFooterView = UIView()
        
        submitButton.setCorner(with: submitButton.frame.height / 2)
    }
    
    fileprivate func search(for username: String) {
        RestClientService.request(.searchUsername, ["search_term": username], nil, .get) { _, json in
            if let usersJson = json?["users"] as? [[String: Any]] {
                self.returnedUsers = Mapper<Profile>().mapArray(JSONArray: usersJson)
                
                guard self.returnedUsers != nil else {
                    return
                }
                
                self.reload(table: .returnedTable)
            }
        }
    }
    
    func reload(table: Table) {
        switch table {
        case .returnedTable:
            guard let users = returnedUsers else {
                return
            }
            userReturnedDataSource.refresh(with: users)
            returnedUsersTableView.reloadData()
        case .selectedTable:
            userSelectedDataSource.refresh(with: selectedUsers)
            userCollectionView.reloadData()
        }
        
        UIView.animate(withDuration: 0.5) {
            if self.selectedUsers.isEmpty {
                self.returnedTableViewTopConstraint.constant = 0
                self.submitButtonBottomConstraint.constant = -self.submitButton.frame.height
                self.submitButton.isHidden = true
            } else {
                self.returnedTableViewTopConstraint.constant = 40
                self.submitButtonBottomConstraint.constant = 10
                self.submitButton.isHidden = false
            }
        }
        
        returnedTableViewTopConstraint.constant = selectedUsers.isEmpty ? 0 : 40
    }
    
    fileprivate func presentSearchResults(_ item: Any) {
        guard let vC = UIStoryboard(name: "PostSearchResults", bundle: nil).instantiateInitialViewController() as? UsersPhotosResultsViewController else {
            return
        }
        
        navigationController?.pushViewController(vC, animated: true)
        vC.setup(item)
    }
    
    fileprivate func adjust(_ user: Profile) {
        if let index = selectedUsers.index(where: { $0.id ?? "" == user.id ?? "" }) {
            selectedUsers.remove(at: index)
        } else {
            selectedUsers.append(user)
        }
        
        reload(table: .selectedTable)
    }
    
    // MARK: - Actions
    @IBAction func submitButton(_ sender: Any) {
        presentSearchResults(selectedUsers)
    }
    
    @IBAction func uploadImageButton(_ sender: Any) {
        guard let vC = UIStoryboard(name: "ImageSearch", bundle: nil).instantiateInitialViewController() as? ImageSearchViewController else {
            return
        }
        
        imageSearchViewController = vC
        
        vC.delegate = self
        present(vC, animated: true)
    }
}
extension SearchViewController: ImageSearchViewControllerDelegate {
    
    func didSelectPost(with image: UIImage) {
        selectedSearchPhoto = image
        imageSearchViewController?.dismiss(animated: true)
        presentSearchResults(image)
    }
}
extension SearchViewController: UserSearchCollectionViewCellDelegate {
    
    func userDidTapRemove(_ user: Profile) {
        adjust(user)
    }
}
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        search(for: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UserSearchTableViewCell, let user = cell.user {
            adjust(user)
        }
    }
}
