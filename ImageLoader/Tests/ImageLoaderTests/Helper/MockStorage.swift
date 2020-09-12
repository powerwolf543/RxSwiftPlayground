//
//  MockStorage.swift
//
//  Created by Nixon Shih on 2020/9/13.
//

import Foundation
@testable import ImageLoader

final class MockStorage: Storage {
    static let defaultKey = URL(string: "htts://www.test.com")!
    
    private(set) var map: [URL: Data] = [:]
    
    init(testData: Data? = nil) {
        map[MockStorage.defaultKey] = testData
    }
    
    func store(_ data: Data, forKey key: URL) throws {
        map[key] = data
    }
    
    func retrieve(forKey key: URL) -> Data? {
        return map[key]
    }
}
