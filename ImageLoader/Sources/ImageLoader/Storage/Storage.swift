//
//  Storage.swift
//
//  Created by Nixon Shih on 2020/8/28.
//

import Foundation

/// Represents types which could be stored and retrieved the data
internal protocol Storage {
    /// Stores the data
    /// - Parameters:
    ///   - data: A data that you want to persist
    ///   - key: A `URL` which could be a store identifier
    /// - Throws: ImageLoaderError.storeError
    func store(_ data: Data, forKey key: URL) throws
    
    /// Retrieves data from storage
    /// - Parameter key: A `URL` which could be a store identifier
    /// - Returns: A data for the specific key.
    func retrieve(forKey key: URL) -> Data?
}
