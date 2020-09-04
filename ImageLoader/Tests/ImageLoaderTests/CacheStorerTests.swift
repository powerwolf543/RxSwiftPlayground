//
//  CacheStorerTests.swift
//  
//  Created by Nixon Shih on 2020/9/4.
//

@testable import ImageLoader
import XCTest

final class CacheStorerTests: XCTestCase {
    func testStoreData() throws {
        let key = URL(string: "htts://www.testStoreData.com")!
        let data = Data("testStoreData".utf8)
        let memoryStorer = MockStorer()
        let diskStorer = MockStorer()
        let cacheStorer = CacheStorer(memoryStorer: memoryStorer, diskStorer: diskStorer)
        try cacheStorer.store(data, forKey: key)
        
        XCTAssertEqual(memoryStorer.map[key], data)
        XCTAssertEqual(diskStorer.map[key], data)
    }
    
    func testMemoryStorerHasData() {
        let memoryData = Data("memoryData".utf8)
        let memoryStorer = MockStorer(testData: memoryData)
        
        let diskData = Data("diskData".utf8)
        let diskStorer = MockStorer(testData: diskData)
        
        let cacheStorer = CacheStorer(memoryStorer: memoryStorer, diskStorer: diskStorer)
        let result = cacheStorer.retrieve(forKey: MockStorer.defaultKey)
        
        XCTAssertNotEqual(result, diskData)
        XCTAssertEqual(result, memoryData)
    }

    func testDiskStorerHasDataAndMemoryStorerEmpty() {
        let memoryStorer = MockStorer()
        
        let diskData = Data("diskData".utf8)
        let diskStorer = MockStorer(testData: diskData)
        
        let cacheStorer = CacheStorer(memoryStorer: memoryStorer, diskStorer: diskStorer)
        let result = cacheStorer.retrieve(forKey: MockStorer.defaultKey)
        
        XCTAssertEqual(result, diskData)
    }
    
    func testFileNotFound() {
        let memoryStorer = MockStorer()
        let diskStorer = MockStorer()
        let cacheStorer = CacheStorer(memoryStorer: memoryStorer, diskStorer: diskStorer)
        let result = cacheStorer.retrieve(forKey: URL(string: "https://testFileNotFound.com")!)
        
        XCTAssertNil(result)
    }
}

private final class MockStorer: Storer {
    static let defaultKey = URL(string: "htts://www.test.com")!
    
    private(set) var map: [URL: Data] = [:]
    
    init(testData: Data? = nil) {
        map[MockStorer.defaultKey] = testData
    }
    
    func store(_ data: Data, forKey key: URL) throws {
        map[key] = data
    }
    
    func retrieve(forKey key: URL) -> Data? {
        return map[key]
    }
}
