//
//  DiskStorer.swift
//
//  Created by Nixon Shih on 2020/8/28.
//

import Foundation

/// The storer that manage to store and retrieve the data to local storage
internal final class DiskStorer: Storer {
    private let storeURL: URL
    private let privateQueue: DispatchQueue
    
    internal init() {
        storeURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        privateQueue = DispatchQueue(label: "com.DiskStorer.privateQueue")
    }

    /// Stores the data to local storage
    /// - Parameters:
    ///   - data: A data that you want to persist
    ///   - key: A string which can be a store identifier
    /// - Throws: ImageLoaderError.diskStorerError
    internal func store(_ data: Data, forKey key: URL) throws {
        let destinationURL = getDestination(with: key)
        try privateQueue.sync {
            do {
                try data.write(to: destinationURL)
            } catch {
                throw ImageLoaderError.diskStorerError(error)
            }
        }
    }

    /// Retrieve data from local storage
    /// - Parameter key: A string which can be a store identifier
    /// - Throws: ImageLoaderError.diskStorerError
    /// - Returns: A data for a specific key.
    internal func retrieve(forKey key: URL) throws -> Data {
        let destinationURL = getDestination(with: key)
        return try privateQueue.sync {
            do {
                return try Data(contentsOf: destinationURL)
            } catch {
                throw ImageLoaderError.diskStorerError(error)
            }
        }
    }
    
    private func getDestination(with key: URL) -> URL {
        storeURL.appendingPathComponent(key.absoluteString.sha256)
    }
}
