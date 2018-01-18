//
//  CommentsDataSource.swift
//  FindMyFace
//
//  Created by Developer on 11/28/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class CommentsDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    private var comments: [Comment]?
    
    func refresh(with comments: [Comment]) {
        self.comments = comments
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CommentTableViewCell.self, for: indexPath)
        if let comment = comments?[indexPath.row] {
            cell.setup(comment)
        }
        return cell
    }
}
