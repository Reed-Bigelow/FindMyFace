//
//  UserSearchDataSource.swift
//  FindMyFace
//
//  Created by Developer on 11/29/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class UserSearchDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    private var users: [Profile]?
    
    // MARK: - Public
    func refresh(with users: [Profile]) {
        self.users = users
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserSearchTableViewCell.self, for: indexPath)
        
        if let user = users?[indexPath.row] {
            cell.setup(with: user)
        }
        
        cell.selectionStyle = .none
        return cell
    }
}
