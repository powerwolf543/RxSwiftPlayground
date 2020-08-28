//
//  RemoteImageSource.swift
//
//  Created by Nixon Shih on 2020/8/28.
//

import CoreImage
import Foundation

/// A image fetcher that manage to fetch the image data from remote
internal final class RemoteImageFetcher {
    internal let session: URLSession
    
    internal init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Fetchs the image data from remote
    /// - Parameters:
    ///   - url: The remote image's url.
    ///   - completionHandler: Called when the download progress finishes. 
    /// - Returns: The data task of URLSession
    internal func fetchImage(with url: URL, completionHandler: @escaping (Result<Data, ImageLoaderError>) -> Void) -> URLSessionDataTask {
        session.dataTask(with: url) { [unowned self] data, _, error in
            if let error = error {
                completionHandler(.failure(.networkError(reason: .connection(error))))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.networkError(reason: .emptyResponse)))
                return
            }
            
            guard self.verifyData(data) else {
                completionHandler(.failure(.networkError(reason: .invalidData)))
                return
            }
            
            completionHandler(.success(data))
        }
    }
    
    private func verifyData(_ data: Data) -> Bool {
        CIImage(data: data) != nil
    }
}
