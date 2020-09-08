//
//  PhotoListViewController.swift
//
//  Created by Nixon Shih on 2020/8/21.
//  Copyright © 2020 Nixon Shih. All rights reserved.
//

import Networking
import RxSwift
import UIKit

final internal class PhotoListViewController: UIViewController {
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.setImage(UIImage(named: "search"), for: .search, state: .normal)
        searchBar.value(forKey: "searchField").flatMap { $0 as? UITextField }?.textColor = UIColor(white: 0.7, alpha: 1)
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var dataSource: [PhotoInfo] = []
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Function
    
    override func loadView() {
        super.loadView()
        view = tableView
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIs()
        
        HTTPClient().fetchDataModel(request: PhotosRequest()).observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] models in
            self.dataSource = models
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func setupUIs() {
        view.backgroundColor = UIColor(white: 29.0 / 255.0, alpha: 1.0)
        navigationItem.titleView = searchBar
        
        tableView.dataSource = self
    }
}

extension PhotoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        let model = dataSource[indexPath.row]
        cell.label.text = model.title
        return cell
    }
}
