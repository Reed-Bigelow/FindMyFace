//
//  NewPostViewController.swift
//  FindMyFace
//
//  Created by Developer on 10/25/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    // MARK: - Properties
    private var newPostPageViewController: NewPostPageViewController?
    
    // MARK: - Private
    fileprivate func adjustNavigationButtons(to page: Int) {
        libraryButton.titleLabel?.textColor = page == 0 ? #colorLiteral(red: 0.4120000005, green: 0.4120000005, blue: 0.4120000005, alpha: 1): #colorLiteral(red: 0.6669999957, green: 0.6669999957, blue: 0.6669999957, alpha: 1)
        photoButton.titleLabel?.textColor = page == 1 ? #colorLiteral(red: 0.4120000005, green: 0.4120000005, blue: 0.4120000005, alpha: 1): #colorLiteral(red: 0.6669999957, green: 0.6669999957, blue: 0.6669999957, alpha: 1)
    }
    
    private func move(to pageNumber: Int) {
        adjustNavigationButtons(to: pageNumber)
        newPostPageViewController?.move(to: pageNumber)
    }
    
    // MARK: - Actions
    @IBAction func libraryAction(_ sender: Any) {
        move(to: 0)
    }
    @IBAction func photoAction(_ sender: Any) {
        move(to: 1)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func postAction(_ sender: Any) {
        RestClientService.uploadData(with: #imageLiteral(resourceName: "Camera-Active"), ["user_id": "8dd5fe13-1273-4138-b1ec-ac168b2480b5"])
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NewPostPageViewController {
            newPostPageViewController = vc
            vc.pageDelegate = self
        }
    }
}
extension NewPostViewController: NewPostPageViewControllerDelegate {
    
    func didMoveToNewPage(_ pageNumber: Int) {
        adjustNavigationButtons(to: pageNumber)
    }
}
