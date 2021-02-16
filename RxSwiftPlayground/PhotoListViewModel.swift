//
//  PhotoListViewModel.swift
//
//  Created by Nixon Shih on 2021/2/16.
//  Copyright © 2021 Nixon Shih. All rights reserved.
//

import Foundation
import Networking
import RxSwift

final internal class PhotoListViewModel {
    internal let datas: Observable<[PhotoInfo]>

    internal init(
        viewWillAppear: Observable<Void>,
        networkClient: NetworkClient
    ) {
        datas = viewWillAppear.flatMapLatest {
            networkClient.fetchDataModel(request: PhotosRequest())
        }
    }
}
