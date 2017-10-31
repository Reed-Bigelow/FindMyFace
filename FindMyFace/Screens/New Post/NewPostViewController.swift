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
    private var currentPhoto: UIImage?
    
    // MARK: - Private
    fileprivate func adjustNavigationButtons(to screen: Screen) {
        libraryButton.titleLabel?.textColor = screen == .library ? #colorLiteral(red: 0.4120000005, green: 0.4120000005, blue: 0.4120000005, alpha: 1): #colorLiteral(red: 0.6669999957, green: 0.6669999957, blue: 0.6669999957, alpha: 1)
        photoButton.titleLabel?.textColor = screen == .photo ? #colorLiteral(red: 0.4120000005, green: 0.4120000005, blue: 0.4120000005, alpha: 1): #colorLiteral(red: 0.6669999957, green: 0.6669999957, blue: 0.6669999957, alpha: 1)
    }
    
    private func move(to screen: Screen) {
        adjustNavigationButtons(to: screen)
        newPostPageViewController?.move(to: screen)
    }
    
    // MARK: - Actions
    @IBAction func libraryAction(_ sender: Any) {
        move(to: .library)
    }
    @IBAction func photoAction(_ sender: Any) {
        move(to: .photo)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func postAction(_ sender: Any) {
        guard let image = currentPhoto else {
            return
        }
        
        RestClientService.uploadData(with: image, ["user_id": "8dd5fe13-1273-4138-b1ec-ac168b2480b5"])
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
    
    func didTakePhoto(_ photo: UIImage) {
        currentPhoto = photo
    }
    
    func didMoveToNewPage(_ screen: Screen) {
        adjustNavigationButtons(to: screen)
    }
}
