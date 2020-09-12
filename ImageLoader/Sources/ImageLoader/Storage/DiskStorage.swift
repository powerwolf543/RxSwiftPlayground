//
//  DiskStorage.swift
//
//  Created by Nixon Shih on 2020/8/28.
//

import Foundation

/// The storage that manages to store and retrieve the data to local storage
internal final class DiskStorage: Storage {
    private let pathProvider: DiskPathProvider
    private let privateQueue: DispatchQueue
    
    internal init(pathProvider: DiskPathProvider = DiskPathProvider()) {
        self.pathProvider = pathProvider
        privateQueue = DispatchQueue(label: "com.DiskStorage.privateQueue", attributes: .concurrent)
    }

    /// Stores the data to local storage
    /// - Parameters:
    ///   - data: A data that you want to persist
    ///   - key: A `URL` which could be a store identifier
    /// - Throws: ImageLoaderError.storeError
    internal func store(_ data: Data, forKey key: URL) throws {
        let cacheURL = pathProvider.getStorePath(with: key)
        try privateQueue.sync(flags: .barrier) {
            do {
                try data.write(to: cacheURL)
            } catch {
                throw ImageLoaderError.storeError
            }
        }
    }

    /// Retrieves data from local storage
    /// - Parameter key: A `URL` which could be a store identifier
    /// - Returns: A data for the specific key.
    internal func retrieve(forKey key: URL) -> Data? {
        privateQueue.sync {
            let cacheURL = pathProvider.getStorePath(with: key)
            return try? Data(contentsOf: cacheURL)
        }
    }
}

/// The path provider that provides the URL of disk storage
internal struct DiskPathProvider {
    private let cachesDirectoryURL: URL
    
    internal init(cachesDirectoryURL: URL? = nil) {
        self.cachesDirectoryURL = cachesDirectoryURL ?? FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    internal func getStorePath(with key: URL) -> URL {
        cachesDirectoryURL.appendingPathComponent(key.absoluteString.sha256)
    }
}
