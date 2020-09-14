//
//  CacheStorage.swift
//  
//  Created by Nixon Shih on 2020/9/3.
//

import Foundation

/// The storage that manages to cache the data to the memory or disk
public final class CacheStorage: Storage {
    public static let shared: CacheStorage = CacheStorage(memoryStorage: MemoryStorage(), diskStorage: DiskStorage())
    
    private let memoryStorage: Storage
    private let diskStorage: Storage

    /// CacheStorage initializer
    /// - Parameters:
    ///   - memoryStorage: A storage that stores data to memory
    ///   - diskStorage: A storage that stores data to disk
    internal init(memoryStorage: Storage, diskStorage: Storage) {
        self.memoryStorage = memoryStorage
        self.diskStorage = diskStorage
    }
    
    /// Caches the data to memory and disk
    /// - Parameters:
    ///   - data: A data that you want to persist
    ///   - key: A `URL` which could be a store identifier
    /// - Throws: ImageLoaderError.storeError
    public func store(_ data: Data, forKey key: URL) throws {
        try memoryStorage.store(data, forKey: key)
        try diskStorage.store(data, forKey: key)
    }
    
     /// Retrieves data from storage
     /// - Parameter key: A `URL` which could be a store identifier
     /// - Returns: A data for the specific key.
    public func retrieve(forKey key: URL) -> Data? {
        if let data = memoryStorage.retrieve(forKey: key) {
            return data
        } else if let data = diskStorage.retrieve(forKey: key) {
            return data
        } else {
            return nil
        }
    }
}
