//
//  AppDelegate.swift
//  CheapestPath
//
//  Created by Todor Brachkov on 15/01/2019.
//  Copyright © 2019 TB. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tripSelectorViewController = TripSelectorViewController(nibName: "TripSelectorViewController", bundle: nil)
        
        let frame = UIScreen.main.bounds
        let window = UIWindow(frame: frame)
        
        window.rootViewController = tripSelectorViewController
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
}

