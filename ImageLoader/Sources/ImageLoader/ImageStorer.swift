//
//  ImageStorer.swift
//
//  Created by Nixon Shih on 2020/8/28.
//

import Foundation

/// Represents types which can be stored and retrieved the image data
internal protocol ImageStorer {
    /// Stores the data
    /// - Parameters:
    ///   - data: A data that you want to persist
    ///   - key: A string which can be a store identifier
    /// - Throws: ImageLoaderError.diskStorerError
    func store(_ data: Data, forKey key: URL) throws
    
    /// Retrieve data from storer
    /// - Parameter key: A string which can be a store identifier
    /// - Throws: ImageLoaderError.diskStorerError
    /// - Returns: A data for a specific key.
    func retrieve(forKey key: URL) throws -> Data
}
