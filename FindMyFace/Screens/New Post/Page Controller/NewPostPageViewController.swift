//
//  NewPostPageViewController.swift
//  FindMyFace
//
//  Created by Developer on 10/25/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

protocol NewPostPageViewControllerDelegate: class {
    
    func didMoveToNewPage(_ pageNumber: Int)
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
        
        move(to: 0)
    }
    
    // MARK: - Public
    func move(to pageNumber: Int) {
        let direction: UIPageViewControllerNavigationDirection = pageNumber == 1 ? .forward: .reverse
        setViewControllers([vcs[pageNumber]], direction: direction, animated: true, completion: nil)
    }
}
extension NewPostPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstVC = viewControllers?.first, let index = vcs.index(of: firstVC) {
            pageDelegate?.didMoveToNewPage(index)
        }
    }
}
