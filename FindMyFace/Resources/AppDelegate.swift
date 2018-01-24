//
//  AppDelegate.swift
//  FindMyFace
//
//  Created by Developer on 10/18/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import FCUUID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        UserDefaults.setValue("7cbc70e1-f5f3-4b11-ab20-ed52c2ca8be7", forKey: .id)
        
        UserDefaults.setValue(nil, forKey: .id)
        
        if UserDefaults.value(forKey: .id) == nil {
            let vC = UIStoryboard(name: "Welcome", bundle: nil).instantiateInitialViewController()
            window?.rootViewController = vC
        }
        
        return true
    }
}
