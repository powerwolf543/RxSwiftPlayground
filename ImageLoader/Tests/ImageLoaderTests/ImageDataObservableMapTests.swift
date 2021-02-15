//
//  ImageDataObservableMapTests.swift
//
//  Created by Nixon Shih on 2020/9/12.
//

@testable import ImageLoader
import RxSwift
import XCTest

final class ImageDataObservableMapTests: XCTestCase {
    func testSetAndGetConcurrently() {
        let baseURL = URL(string: "http://www.ImageDataObservableMap.test.com")!
        let testTimes = 10
        let bag = DisposeBag()
        let map = ImageDataObservableMap()
        let datas = (0..<testTimes)
            .map(String.init)
            .reduce(into: [URL: Data]()) { $0[baseURL.appendingPathComponent($1)] = Data("test \($1)".utf8) }
        
        let setExpectation = expectation(description: "Wait for set values")
        setExpectation.expectedFulfillmentCount = testTimes
        
        for (key, value) in datas {
            DispatchQueue.global().async {
                map[key] = Observable<Data>.create { observer in
                    observer.onNext(value)
                    observer.onCompleted()
                    return Disposables.create()
                }
                setExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
        XCTAssertEqual(map.count, 10)
        
        let readExpectation = expectation(description: "Wait for read data")
        readExpectation.expectedFulfillmentCount = testTimes
        
        for (key, value) in datas {
            DispatchQueue.global().async {
                guard let observable = map[key] else {
                    XCTAssertNotNil(map[key])
                    return
                }
                
                observable
                    .subscribe(
                        onNext: { XCTAssertEqual($0, value) },
                        onCompleted: { readExpectation.fulfill() }
                    )
                    .disposed(by: bag)
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}
