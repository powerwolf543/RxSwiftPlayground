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
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Override functions
    
    override internal func loadView() {
        super.loadView()
        view = tableView
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()

        setupUIs()
    }

    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let viewModel = PhotoListViewModel(
            viewWillAppear: Observable<Void>.just(()),
            networkClient: HTTPClient()
        )

        viewModel.datas
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: PhotoTableViewCell.self)) { (row, data, cell) in
                cell.label.text = data.title
                ImageLoader().retrieveImage(with: data.thumbnailURL).bind(to: cell.contentImageView.rx.image).disposed(by: cell.bag)
            }
            .disposed(by: disposeBag)
    }

    override internal func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        disposeBag = DisposeBag()
    }

    // MARK: Other functions

    private func setupUIs() {
        view.backgroundColor = UIColor(white: 29.0 / 255.0, alpha: 1.0)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        navigationItem.titleView = searchBar

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension PhotoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
