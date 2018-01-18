//
//  UITableView+Extensions.swift
//  FindMyFace
//
//  Created by Developer on 11/28/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError()
        }
        
        return cell
    }
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        let identifier = String(describing: T.self)
        register(T.self, forCellReuseIdentifier: identifier)
    }
    
    func registerNib<T: UITableViewCell>(_ cellType: T.Type) {
        let identifier = String(describing: T.self)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
}
