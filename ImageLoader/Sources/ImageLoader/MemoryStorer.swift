//
//  MemoryStorer.swift
//
//  Created by Nixon Shih on 2020/8/29.
//

import Foundation

/// The storer that manage to store and retrieve the data to memory
internal final class MemoryStorer: Storer {
    internal let caches: NSCache<NSString, CacheContainer>
    private let privateQueue: DispatchQueue
    
    internal init() {
        caches = NSCache<NSString, CacheContainer>()
        privateQueue = DispatchQueue(label: "com.DiskStorer.privateQueue")
        caches.totalCostLimit = Int(ProcessInfo.processInfo.physicalMemory / 4)
        caches.countLimit = .max
    }
    
    /// Stores the data to memory
    /// - Parameters:
    ///   - data: A data that you want to cache in memory
    ///   - key: A string which can be a store identifier
    /// - Throws: ImageLoaderError.memoryStorerError
    internal func store(_ data: Data, forKey key: URL) throws {
        privateQueue.sync {
            caches.setObject(CacheContainer(data), forKey: key.absoluteString as NSString)
        }
    }
    
    /// Retrieve data from memory
    /// - Parameter key: A string which can be a store identifier
    /// - Throws: ImageLoaderError.memoryStorerError
    /// - Returns: A data for a specific key.
    internal func retrieve(forKey key: URL) throws -> Data {
        try privateQueue.sync {
            guard let container = caches.object(forKey: key.absoluteString as NSString) else {
                throw ImageLoaderError.memoryStorerError(reason: .dataNotFound)
            }
            return container.raw
        }
    }
}

extension MemoryStorer {
    internal final class CacheContainer {
        internal let raw: Data
        
        internal init(_ raw: Data) {
            self.raw = raw
        }
    }
}
