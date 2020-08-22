//
//  NetworkRequest.swift
//
//  Created by Nixon Shih on 2020/8/22.
//

import Foundation
import RxSwift

public protocol NetworkRequest {
    associatedtype Response: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    
    func buildRequest() -> Observable<URLRequest>
}

extension NetworkRequest {
    public var baseURL: URL { URL(string: "https://jsonplaceholder.typicode.com/")! }

    public func buildRequest() -> Observable<URLRequest> {
        Observable.create { observer in
            let fullURL = self.baseURL.appendingPathComponent(self.path)
            var request = URLRequest(url: fullURL)
            request.httpMethod = self.method.rawValue
            observer.onNext(request)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
