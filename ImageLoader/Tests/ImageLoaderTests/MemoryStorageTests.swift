//
//  MemoryStorageTests.swift
//
//  Created by Nixon Shih on 2020/8/29.
//

@testable import ImageLoader
import XCTest

final class MemoryStorageTests: XCTestCase {
    func testStoreAndRetrieveSameKey() throws {
        let key = URL(string: "https://www.example.com/some/love.png")!
    
        let data1 = Data("test text1".utf8)
        let storage = MemoryStorage()
        try storage.store(data1, forKey: key)
        let retrievedData1 = storage.retrieve(forKey: key)
        XCTAssertEqual(data1, retrievedData1)
        
        let data2 = Data("test text2".utf8)
        try storage.store(data2, forKey: key)
        let retrievedData2 = storage.retrieve(forKey: key)
        XCTAssertEqual(data2, retrievedData2)
        
        let data3 = Data("test text3".utf8)
        try storage.store(data3, forKey: key)
        let retrievedData3 = storage.retrieve(forKey: key)
        XCTAssertEqual(data3, retrievedData3)
    }
    
    func testStoreAndRetrieveDifferentKeys() throws {
        let data1 = Data("test text1".utf8)
        let key1 = URL(string: "https://www.example.com/some/love1.png")!
        let storage = MemoryStorage()
        try storage.store(data1, forKey: key1)
        let retrievedData1 = storage.retrieve(forKey: key1)
        XCTAssertEqual(data1, retrievedData1)
        
        let data2 = Data("test text2".utf8)
        let key2 = URL(string: "https://www.example.com/some/love2.png")!
        try storage.store(data2, forKey: key2)
        let retrievedData2 = storage.retrieve(forKey: key2)
        XCTAssertEqual(data2, retrievedData2)
        
        let data3 = Data("test text3".utf8)
        let key3 = URL(string: "https://www.example.com/some/love3.png")!
        try storage.store(data3, forKey: key3)
        let retrievedData3 = storage.retrieve(forKey: key3)
        XCTAssertEqual(data3, retrievedData3)
    }
}
