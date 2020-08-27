//
//  AppDelegate.swift
//
//  Created by Nixon Shih on 2020/8/21.
//  Copyright © 2020 Nixon Shih. All rights reserved.
//

import UIKit

@UIApplicationMain
final internal class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?
    
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = NavigationController(rootViewController: PhotoListViewController())
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

