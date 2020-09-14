//
//  DiskPathProviderTests.swift
//  
//  Created by Nixon Shih on 2020/9/12.
//

@testable import ImageLoader
import XCTest

final class DiskPathProviderTests: XCTestCase {
    func testGeneratePathWithKeyCorrectly() {
        let testCacheURL = URL(string: "file://cache/directory")!
        let pathProvider = DiskPathProvider(cachesDirectoryURL: testCacheURL)
        let key = URL(string: "http://key.test.net")!
        
        let storePath = pathProvider.getStorePath(with: key)
        
        let resultExpectation = URL(string: "file://cache/directory/43d20f654c5ad261f4206eed27594769aadaa7b3b0732aefc87d99724fa1c9c8")!
        XCTAssertEqual(storePath, resultExpectation)
    }
}
