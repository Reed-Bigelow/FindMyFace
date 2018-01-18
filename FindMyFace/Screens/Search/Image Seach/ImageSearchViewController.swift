//
//  ImageSearchViewController.swift
//  FindMyFace
//
//  Created by Developer on 12/3/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

protocol ImageSearchViewControllerDelegate: class {
    
    func didSelectPost(with image: UIImage)
}

class ImageSearchViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: ImageSearchViewControllerDelegate?
    private var selectedImage: UIImage?
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vC = segue.destination as? NewPostLibraryViewController {
            vC.delegate = self
        }
    }
    
    // MARK: - Actions
    @IBAction func searchButton(_ sender: Any) {
        guard let image = selectedImage else {
            return
        }
        
        delegate?.didSelectPost(with: image)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
extension ImageSearchViewController: NewPostLibraryViewControllerDelegate {
    
    func didSelectPhoto(_ photo: UIImage) {
        selectedImage = photo
    }
}
