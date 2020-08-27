//
//  NavigationController.swift
//
//  Created by Nixon Shih on 2020/8/25.
//  Copyright © 2020 Nixon Shih. All rights reserved.
//

import UIKit

internal final class NavigationController: UINavigationController {
    override internal var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.tintColor = UIColor(red: 244.0 / 255.0, green: 147.0 / 255.0, blue: 11.0 / 255.0, alpha: 1.0)
        navigationBar.barTintColor = UIColor(white: 16.0 / 255.0, alpha: 1.0)
    }
}

