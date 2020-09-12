//
//  ImageDataObservableMapTests.swift
//
//  Created by Nixon Shih on 2020/9/12.
//

@testable import ImageLoader
import RxSwift
import XCTest

final class ImageDataObservableMapTests: XCTestCase {
    func testSetAndGet() {
        let baseURL = URL(string: "http://www.ImageDataObservableMap.test.com")!
        let map = ImageDataObservableMap()
        let keysAndResults = (0..<10)
            .map(String.init)
            .map { (baseURL.appendingPathComponent($0), Data("test \($0)".utf8)) }
        
        for (key, result) in keysAndResults {
            map[key] = Observable<Data>.create { observer in
                observer.onNext(result)
                observer.onCompleted()
                return Disposables.create()
            }
        }
        
        XCTAssertEqual(map.count, 10)
                
        for (key, result) in keysAndResults {
            guard let observable = map[key] else {
                XCTAssertNotNil(map[key])
                return
            }
                        
            let subscriptionExpectation = expectation(description: "subscription")
            
            _ = observable.subscribe(onNext: {
                XCTAssertEqual($0, result)
                subscriptionExpectation.fulfill()
            })
        }
        
        waitForExpectations(timeout: 1)
    }
}
