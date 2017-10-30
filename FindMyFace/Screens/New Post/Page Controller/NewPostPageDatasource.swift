//
//  NewPostPageDatasource.swift
//  FindMyFace
//
//  Created by Developer on 10/25/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

class NewPostPageDatasource: NSObject, UIPageViewControllerDataSource {
    
    // MARK: - Properties
    private var viewControllers: [UIViewController]?
    
    // MARK: - Lifecycle
    init(viewControllers: [UIViewController]) {
        super.init()
        self.viewControllers = viewControllers
    }
    
    // MARK: - Public
    func refresh(with viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
    
    // MARK: - Datasource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers?.index(of: viewController) else {
            return nil
        }
        
        let prevIndex = index - 1
        let viewControllerCount = viewControllers?.count ?? 0
        
        guard prevIndex >= 0, viewControllerCount > prevIndex, let viewController = viewControllers?[prevIndex] else {
            return nil
        }
        
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers?.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = index + 1
        let viewControllerCount = viewControllers?.count ?? 0
        
        guard viewControllerCount != nextIndex, viewControllerCount > nextIndex, let viewController = viewControllers?[nextIndex] else {
            return nil
        }
        
        return viewController
    }
}
