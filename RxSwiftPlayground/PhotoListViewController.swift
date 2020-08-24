//
//  PhotoListViewController.swift
//
//  Created by Nixon Shih on 2020/8/21.
//  Copyright © 2020 Nixon Shih. All rights reserved.
//

import UIKit
import RxSwift

final internal class PhotoListViewController: UIViewController {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.setImage(UIImage(named: "search"), for: .search, state: .normal)
        searchBar.value(forKey: "searchField").flatMap { $0 as? UITextField }?.textColor = UIColor(white: 0.7, alpha: 1)
        return searchBar
    }()
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Function
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIs()
    }
    
    private func setupUIs() {
        view.backgroundColor = UIColor(white: 29.0 / 255.0, alpha: 1.0)
        navigationItem.titleView = searchBar
    }
}

