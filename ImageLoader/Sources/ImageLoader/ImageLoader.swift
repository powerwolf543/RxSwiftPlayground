//
//  ImageLoader.swift
//
//  Created by Nixon Shih on 2020/9/12.
//

import RxSwift
import UIKit

/// A simple image loader that downloads the image from remote and caches in the memory and disk.
public final class ImageLoader {
    /// A image source that manages to download the image
    private let remoteImageSource: RemoteImageSource
    /// A storage that manages to cache the data.
    private let cacheStorage: Storage
    
    /// ImageLoader initializer
    /// - Parameters:
    ///   - remoteImageSource: A storage that manages to cache the data.
    ///   - cacheStorage: A image source that manages to download the image
    public init(
        remoteImageSource: RemoteImageSource = RemoteImageSource.shared,
        cacheStorage: Storage = CacheStorage.shared
    ) {
        self.remoteImageSource = remoteImageSource
        self.cacheStorage = cacheStorage
    }
    
    /// Retrieves an `UIImage` from a given `URL`.
    /// - Parameter url: an image URL
    /// - Returns: An observable sequence of `UIImage`
    public func retrieveImage(with url: URL) -> Observable<UIImage?> {
        retrieveImageData(with: url).map(UIImage.init(data:))
    }
    
    /// Retrieves a image data from a given `URL`.
    /// - Parameter url: an image URL
    /// - Returns: An observable sequence of data
    public func retrieveImageData(with url: URL) -> Observable<Data> {
        Observable<Data?>.create { observer in
            let data = self.cacheStorage.retrieve(forKey: url)
            observer.onNext(data)
            observer.onCompleted()
            return Disposables.create()
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
        .flatMap { data -> Observable<Data> in
            if let data = data { return Observable.just(data) }
            return self.remoteImageSource.fetchImage(with: url).map { data in
                try? self.cacheStorage.store(data, forKey: url)
                return data
            }
        }
    }
}
