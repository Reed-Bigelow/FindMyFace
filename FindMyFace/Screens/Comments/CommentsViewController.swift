//
//  CommentsViewController.swift
//  FindMyFace
//
//  Created by Developer on 11/28/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import ObjectMapper

class CommentsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextFieldView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var postId: String?
    private var comments: [Comment]?
    private lazy var dataSource: CommentsDataSource = {
       CommentsDataSource()
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Private
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillMove), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        reloadNetworkData()
        navigationItem.title = "Comments"
    }
    
    private func reloadNetworkData() {
        RestClientService.request(.postComments, ["post_id": postId ?? ""], nil, .get) { _, json in
            if let commentJson = json?["comments"] as? [[String: Any]] {
                self.comments = Mapper<Comment>().mapArray(JSONArray: commentJson).sorted { $0.timestamp ?? Date() < $1.timestamp ?? Date() }
                
                self.dataSource.refresh(with: self.comments!)
                self.tableView.reloadData()
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                
                if self.comments != nil && !self.comments!.isEmpty {
                    self.tableView.scrollToRow(at: IndexPath(row: (self.comments?.count)! - 1, section: 0), at: .bottom, animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWillMove(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            UIView.animate(withDuration: 0.2, animations: {
                if keyboardSize.origin.y < Constants.ScreenDimensions.HEIGHT {
                    self.bottomConstraint.constant = keyboardSize.height
                    
                    if Constants.DeviceType.iPhoneX {
                        self.bottomConstraint.constant -= 34
                    }
                } else {
                    self.bottomConstraint.constant = 0
                }
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func postButton(_ sender: Any) {
        let parameters = ["user_id": UserDefaults.value(forKey: .id) as? String ?? "",
                          "post_id": postId ?? "",
                          "comment": textField.text ?? ""]
        
        RestClientService.request(.postComments, nil, parameters, .post) { success, _ in
            if success {
                self.textField.text = ""
                self.reloadNetworkData()
            }
        }
    }
}
extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let comments = comments {
            return (comments[indexPath.row].comment ?? "").estimatedHeight(Constants.ScreenDimensions.WIDTH, 13) + 50
        } else {
            return 0
        }
    }
}
