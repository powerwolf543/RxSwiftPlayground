//
//  PhotoListViewController.swift
//
//  Created by Nixon Shih on 2020/8/21.
//  Copyright © 2020 Nixon Shih. All rights reserved.
//

import ImageLoader
import Networking
import RxCocoa
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

        HTTPClient()
            .fetchDataModel(request: PhotosRequest())
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { object, value in
                object.dataSource = value
                object.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUIs() {
        view.backgroundColor = UIColor(white: 29.0 / 255.0, alpha: 1.0)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        navigationItem.titleView = searchBar
        
        tableView.dataSource = self
        tableView.delegate = self
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
        ImageLoader().retrieveImage(with: model.thumbnailURL).bind(to: cell.contentImageView.rx.image).disposed(by: cell.bag)
        return cell
    }
}

extension PhotoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
