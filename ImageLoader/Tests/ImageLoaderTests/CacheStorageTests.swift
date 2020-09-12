//
//  CacheStorageTests.swift
//  
//  Created by Nixon Shih on 2020/9/4.
//

@testable import ImageLoader
import XCTest

final class CacheStorageTests: XCTestCase {
    func testStoreData() throws {
        let key = URL(string: "htts://www.testStoreData.com")!
        let data = Data("testStoreData".utf8)
        let memoryStorage = MockStorage()
        let diskStorage = MockStorage()
        let cacheStorage = CacheStorage(memoryStorage: memoryStorage, diskStorage: diskStorage)
        try cacheStorage.store(data, forKey: key)
        
        XCTAssertEqual(memoryStorage.map[key], data)
        XCTAssertEqual(diskStorage.map[key], data)
    }
    
    func testMemoryStorageHasData() {
        let memoryData = Data("memoryData".utf8)
        let memoryStorage = MockStorage(testData: memoryData)
        
        let diskData = Data("diskData".utf8)
        let diskStorage = MockStorage(testData: diskData)
        
        let cacheStorage = CacheStorage(memoryStorage: memoryStorage, diskStorage: diskStorage)
        let result = cacheStorage.retrieve(forKey: MockStorage.defaultKey)
        
        XCTAssertNotEqual(result, diskData)
        XCTAssertEqual(result, memoryData)
    }

    func testDiskStorageHasDataAndMemoryStorageEmpty() {
        let memoryStorage = MockStorage()
        
        let diskData = Data("diskData".utf8)
        let diskStorage = MockStorage(testData: diskData)
        
        let cacheStorage = CacheStorage(memoryStorage: memoryStorage, diskStorage: diskStorage)
        let result = cacheStorage.retrieve(forKey: MockStorage.defaultKey)
        
        XCTAssertEqual(result, diskData)
    }
    
    func testFileNotFound() {
        let memoryStorage = MockStorage()
        let diskStorage = MockStorage()
        let cacheStorage = CacheStorage(memoryStorage: memoryStorage, diskStorage: diskStorage)
        let result = cacheStorage.retrieve(forKey: URL(string: "https://testFileNotFound.com")!)
        
        XCTAssertNil(result)
    }
}
