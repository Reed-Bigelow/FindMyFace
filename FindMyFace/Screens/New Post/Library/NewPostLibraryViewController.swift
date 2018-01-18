//
//  NewPostViewController.swift
//  FindMyFace
//
//  Created by Developer on 10/24/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import Photos

protocol NewPostLibraryViewControllerDelegate: class {
    
    func didSelectPhoto(_ photo: UIImage)
}

class NewPostLibraryViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    private lazy var datasource: PhotoLibraryCollectionDataSource = {
        PhotoLibraryCollectionDataSource()
    }()
    private var images = [UIImage]()
    weak var delegate: NewPostLibraryViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the view
        setup()
    }
    
    // MARK: - Actions
    @IBAction func post(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Private
    private func setup() {
        
        // Toggle loading
        toggleLoading()
        
        // Set the datasource and delegate
        collectionView.dataSource = datasource
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        
        // Set the image content type
        selectedImage.contentMode = .scaleAspectFill
        
        // Get images and reload the data
        reloadData()
    }
    
    // MARK: - Private
    private func toggleLoading() {
        DispatchQueue.main.async {
            if self.activitySpinner.isAnimating {
                self.activitySpinner.stopAnimating()
            } else {
                self.activitySpinner.startAnimating()
            }
            
            self.activitySpinner.isHidden = !self.activitySpinner.isAnimating
        }
    }
    
    private func reloadData() {
        // Gather the images
        PHPhotoLibrary.shared().allImages { images in
            
            // Set the gathered images
            guard let images = images else {
                return
            }
            
            self.images = images
            
            // Reload the collection view data
            self.datasource.refresh(with: self.images)
            
            // Reload the view
            DispatchQueue.main.sync {
                self.collectionView.reloadData()
            }
            
            // Set the selected image to the first one
            self.setSelectedImage(for: 0)
            DispatchQueue.main.async {
                 self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.top)
            }
            
            // Stop the spinner
            self.toggleLoading()
        }
    }
    
    private func setSelectedImage(for item: Int) {
        let image = PHPhotoLibrary.shared().image(at: item)
        
        DispatchQueue.main.async {
            self.selectedImage.image = image
        }
        
        delegate?.didSelectPhoto(image)
    }
    
    private func deselectAllCells() {
        collectionView.visibleCells.forEach { $0.isSelected = false }
    }
}
extension NewPostLibraryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deselectAllCells()
        setSelectedImage(for: indexPath.item)
    }
    
    // MARK: - Collection View Delegate Flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = Constants.ScreenDimensions.WIDTH / 4
        return CGSize(width: cellSize, height: cellSize)
    }
}
