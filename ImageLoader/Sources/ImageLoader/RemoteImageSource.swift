//
//  RemoteImageSource.swift
//
//  Created by Nixon Shih on 2020/8/28.
//

import CoreImage
import Foundation
import RxSwift

/// A image fetcher that manages to fetch the image data from remote
internal final class RemoteImageSource {
    internal static let shared: RemoteImageSource = RemoteImageSource(session: .shared)
    
    private let session: URLSession
    private let observableMap: ImageDataObservableMap
    
    /// RemoteImageSource initializer
    /// - Parameter session: Underlying `URLSession` for this instance.
    internal init(session: URLSession) {
        self.session = session
        observableMap = ImageDataObservableMap()
    }
    
    /// Fetches the image data from remote
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
                
                guard let data = data, data.count > 0 else {
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
