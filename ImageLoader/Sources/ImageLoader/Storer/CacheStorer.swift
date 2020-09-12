//
//  CacheStorer.swift
//  
//  Created by Nixon Shih on 2020/9/3.
//

import Foundation
import RxSwift

/// The storer that manage to cache the data to the memory or disk
public final class CacheStorer: Storer {
    public static let shared: CacheStorer = CacheStorer(memoryStorer: MemoryStorer(), diskStorer: DiskStorer())
    
    private let memoryStorer: Storer
    private let diskStorer: Storer

    /// CacheStorer initializer
    /// - Parameters:
    ///   - memoryStorer: A storer that store data to memory
    ///   - diskStorer: A storer that store data to disk
    internal init(memoryStorer: Storer, diskStorer: Storer) {
        self.memoryStorer = memoryStorer
        self.diskStorer = diskStorer
    }
    
    /// Stores the data
    /// - Parameters:
    ///   - data: A data that you want to persist
    ///   - key: A string which can be a store identifier
    /// - Throws: ImageLoaderError.storeError
    public func store(_ data: Data, forKey key: URL) throws {
        try memoryStorer.store(data, forKey: key)
        try diskStorer.store(data, forKey: key)
    }
    
    /// Retrieve data from storer
     /// - Parameter key: A string which can be a store identifier
     /// - Returns: A data for a specific key.
    public func retrieve(forKey key: URL) -> Data? {
        if let data = memoryStorer.retrieve(forKey: key) {
            return data
        } else if let data = diskStorer.retrieve(forKey: key) {
            return data
        } else {
            return nil
        }
    }
}
