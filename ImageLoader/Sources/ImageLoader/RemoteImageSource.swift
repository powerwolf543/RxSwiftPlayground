//
//  RemoteImageSource.swift
//
//  Created by Nixon Shih on 2020/8/28.
//

import CoreImage
import Foundation
import RxSwift

/// A image fetcher that manage to fetch the image data from remote
internal final class RemoteImageSource {
    internal let session: URLSession
    
    internal init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Fetchs the image data from remote
    /// - Parameters:
    ///   - url: The remote image's url.
    ///   - completionHandler: Called when the download progress finishes. 
    /// - Returns: The data task of URLSession
    internal func fetchImage(with url: URL) -> Observable<Data> {
        Observable.create { [unowned self] observer in
            let task = self.session.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self else { return }
                
                if let error = error {
                    observer.onError(ImageLoaderError.networkError(reason: .connection(error)))
                    return
                }
                
                guard let data = data else {
                    observer.onError(ImageLoaderError.networkError(reason: .emptyResponse))
                    return
                }
                
                guard self.verifyData(data) else {
                    observer.onError(ImageLoaderError.networkError(reason: .invalidData))
                    return
                }
                
                observer.onNext(data)
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
    
    private func verifyData(_ data: Data) -> Bool {
        CIImage(data: data) != nil
    }
}
