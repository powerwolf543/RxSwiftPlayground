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
    internal static let shared: RemoteImageSource = RemoteImageSource()
    
    private let session: URLSession
    private let observableMap: ImageDataObservableMap
    
    internal init(session: URLSession = .shared) {
        self.session = session
        observableMap = ImageDataObservableMap()
    }
    
    /// Fetchs the image data from remote
    /// - Parameters:
    ///   - url: The remote image's url.
    /// - Returns: The observable of image data
    internal func fetchImage(with url: URL) -> Observable<Data> {
        let observable = observableMap[url] ?? Observable.create { [unowned self] observer in
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
            return Disposables.create { [weak self] in
                task.cancel()
                self?.observableMap[url] = nil
            }
        }.share(replay: 1)
        
        observableMap[url] = observable
        
        return observable
    }

    private func verifyData(_ data: Data) -> Bool {
        CIImage(data: data) != nil
    }
}
