//
//  RemoteImageSource.swift
//
//  Created by Nixon Shih on 2020/8/28.
//

import CoreImage
import Foundation
import RxSwift

/// A image source that manages to fetch the image data from remote
public final class RemoteImageSource {
    public static let shared: RemoteImageSource = RemoteImageSource(session: .shared)
    
    private let session: URLSession
    private let observableMap: ImageDataObservableMap
    private let dataValidator: DataValidator
    
    /// RemoteImageSource initializer
    /// - Parameter session: Underlying `URLSession` for this instance.
    public convenience init(session: URLSession) {
        self.init(session: session, observableMap: ImageDataObservableMap(), dataValidator: ImageDataValidator())
    }

    internal init(session: URLSession, observableMap: ImageDataObservableMap, dataValidator: DataValidator) {
        self.session = session
        self.observableMap = observableMap
        self.dataValidator = dataValidator
    }
    
    /// Fetches the image data from remote
    /// - Parameters:
    ///   - url: The remote image's url.
    /// - Returns: The observable of image data
    internal func fetchImage(with url: URL) -> Observable<Data> {
        let observable = observableMap[url] ?? Observable.create { observer in
            let task = self.session.dataTask(with: url) { data, _, error in
                if let error = error {
                    observer.onError(ImageLoaderError.networkError(reason: .connection(error)))
                    return
                }
                
                guard let data = data, data.count > 0 else {
                    observer.onError(ImageLoaderError.networkError(reason: .emptyResponse))
                    return
                }
                
                guard self.dataValidator.validateData(data) else {
                    observer.onError(ImageLoaderError.networkError(reason: .invalidData))
                    return
                }
                
                observer.onNext(data)
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create { [weak self] in
                self?.observableMap[url] = nil
            }
        }.share(replay: 1)
        
        observableMap[url] = observable
        
        return observable
    }
}
