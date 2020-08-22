//
//  NetworkClient.swift
//
//  Created by Nixon Shih on 2020/8/22.
//

import Foundation
import RxSwift

public protocol NetworkClient {
    func fetchDataModel<Request>(request: Request) -> Observable<Request.Response> where Request: NetworkRequest
}
