//
//  Sha256Tests.swift
//
//  Created by Nixon Shih on 2020/8/28.
//

@testable import ImageLoader
import RxSwift
import XCTest

final class Sha256Tests: XCTestCase {
    func testPlainText() {
        let result = "Test text".sha256
        XCTAssertEqual(result, "ab0e2c4143f4f6815306af9c90bcc21a06ce5a7c8d365af5ec15d5aa515fdbc1")
    }
    
    func testURL() {
        let url = URL(string: "https://www.example.com/thepath/destination.html?para=123")!
        let result = url.absoluteString.sha256
        XCTAssertEqual(result, "373b7511663871f78ba83164ee0f6693489f023071581c54817d061623f5e4db")
    }
}
