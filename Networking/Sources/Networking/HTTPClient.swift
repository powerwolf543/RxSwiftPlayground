//
//  HTTPClient.swift
//
//  Created by Nixon Shih on 2020/8/22.
//

import Foundation
import RxSwift

final public class HTTPClient: NetworkClient {
    public static let shared: HTTPClient = HTTPClient()
    
    public let session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func fetchDataModel<Request>(request: Request) -> Observable<Request.Response> where Request: NetworkRequest {
        request.buildRequest().flatMap { request -> Observable<Request.Response> in
            self.fetchData(request: request).flatMap { data -> Observable<Request.Response> in
                let dataModel = try JSONDecoder().decode(Request.Response.self, from: data)
                return Observable.just(dataModel)
            }
        }
    }
    
    public func fetchData(request: URLRequest) -> Observable<Data> {
        Observable.create { observer in
            let task = self.session.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    observer.onError(error)
                }
                
                guard let data = data else {
                    observer.onError(Error.emptyResponse)
                    return
                }
                
                observer.onNext(data)
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create(with: task.cancel)
        }
    }
}

extension HTTPClient {
    public enum Error: LocalizedError {
        case emptyResponse
    }
}
