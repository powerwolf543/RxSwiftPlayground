//
//  NetworkRequestTests.swift
//
//  Created by Nixon Shih on 2020/8/23.
//

import Networking
import RxSwift
import XCTest

final class NetworkRequestTests: XCTestCase {
    private let bag = DisposeBag()
    
    func testBuildRequest() {
        let url = URL(string: "https://www.ios.test/")!
        let path = "path"
        let method: HTTPMethod = .get

        TestRequest<String>(baseURL: url, path: path, method: method).buildRequest().subscribe(
            onNext: { request in
                XCTAssertEqual(request.url?.absoluteString, "https://www.ios.test/path")
                XCTAssertEqual(request.httpMethod, method.rawValue)
            },
            onError: { _ in
                XCTFail("Should not be failed.")
            }
        ).disposed(by: bag)
    }
}
