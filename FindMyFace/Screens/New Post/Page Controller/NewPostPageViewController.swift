//
//  NewPostPageViewController.swift
//  FindMyFace
//
//  Created by Developer on 10/25/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

protocol NewPostPageViewControllerDelegate: class {
    
    func didMoveToNewPage(_ screen: Screen)
    func didTakePhoto(_ photo: UIImage)
}

enum Screen: Int {
    case library
    case photo
}

class NewPostPageViewController: UIPageViewController {
    
    // MARK: - Properties
    let vcs = [UIStoryboard(name: "NewPostLibrary", bundle: nil).instantiateInitialViewController()!,
               UIStoryboard(name: "NewPostCamera", bundle: nil).instantiateInitialViewController()!]
    private lazy var datasource: NewPostPageDatasource = {
        return NewPostPageDatasource(viewControllers: vcs)
    }()
    weak var pageDelegate: NewPostPageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = datasource
        delegate = self
        
        // Assign the camera delegate
        if let libraryVC = vcs.first as? NewPostLibraryViewController, let cameraVC = vcs.last as? NewPostCameraViewController {
            libraryVC.delegate = self
            cameraVC.delegate = self
        }
        
        move(to: .library)
    }
    
    // MARK: - Public
    func move(to pageNumber: Screen) {
        let direction: UIPageViewControllerNavigationDirection = pageNumber == .photo ? .forward: .reverse
        setViewControllers([vcs[pageNumber.hashValue]], direction: direction, animated: true, completion: nil)
    }
}
extension NewPostPageViewController: NewPostCameraViewControllerDelegate {
    
    func didTakePhoto(_ photo: UIImage) {
        pageDelegate?.didTakePhoto(photo)
    }
}
extension NewPostPageViewController: NewPostLibraryViewControllerDelegate {
    
    func didSelectPhoto(_ photo: UIImage) {
        pageDelegate?.didTakePhoto(photo)
    }
}
extension NewPostPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstVC = viewControllers?.first, let index = vcs.index(of: firstVC) {
            pageDelegate?.didMoveToNewPage(Screen(rawValue: index) ?? .library)
        }
    }
}
