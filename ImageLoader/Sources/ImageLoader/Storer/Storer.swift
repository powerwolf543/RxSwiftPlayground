//
//  Storer.swift
//
//  Created by Nixon Shih on 2020/8/28.
//

import Foundation

/// Represents types which can be stored and retrieved the data
internal protocol Storer {
    /// Stores the data
    /// - Parameters:
    ///   - data: A data that you want to persist
    ///   - key: A string which can be a store identifier
    /// - Throws: ImageLoaderError.storeError
    func store(_ data: Data, forKey key: URL) throws
    
    /// Retrieve data from storer
    /// - Parameter key: A string which can be a store identifier
    /// - Returns: A data for a specific key.
    func retrieve(forKey key: URL) -> Data?
}
