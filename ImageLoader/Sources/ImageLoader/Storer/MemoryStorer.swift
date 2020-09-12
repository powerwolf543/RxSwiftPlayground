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
    
    internal init(
        totalCostLimit: Int = Int(ProcessInfo.processInfo.physicalMemory / 4),
        countLimit: Int = .max
    ) {
        caches = NSCache<NSString, CacheContainer>()
        privateQueue = DispatchQueue(label: "com.MemoryStorer.privateQueue", attributes: .concurrent)
        caches.totalCostLimit = totalCostLimit
        caches.countLimit = countLimit
    }
    
    /// Stores the data to memory
    /// - Parameters:
    ///   - data: A data that you want to cache in memory
    ///   - key: A string which can be a store identifier
    /// - Throws: ImageLoaderError.storeError
    internal func store(_ data: Data, forKey key: URL) throws {
        privateQueue.sync(flags: .barrier) {
            caches.setObject(CacheContainer(data), forKey: key.absoluteString as NSString)
        }
    }
    
    /// Retrieve data from memory
    /// - Parameter key: A string which can be a store identifier
    /// - Returns: A data for a specific key.
    internal func retrieve(forKey key: URL) -> Data? {
        privateQueue.sync {
            caches.object(forKey: key.absoluteString as NSString)?.raw
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
