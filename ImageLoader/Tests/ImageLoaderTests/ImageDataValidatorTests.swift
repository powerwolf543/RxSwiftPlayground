//
//  ImageDataValidatorTests.swift
//
//  Created by Nixon Shih on 2020/9/12.
//

@testable import ImageLoader
import XCTest

final class ImageDataValidatorTests: XCTestCase {
    func testValidationSuccess() {
        let data = TestImage.imageData
        let result = ImageDataValidator().validateData(data)
        XCTAssertTrue(result)
    }
    
    func testValidationFail() {
        let data = Data("123".utf8)
        let result = ImageDataValidator().validateData(data)
        XCTAssertFalse(result)
    }
}
