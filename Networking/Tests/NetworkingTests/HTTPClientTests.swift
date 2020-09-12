//
//  HTTPClientTests.swift
//
//  Created by Nixon Shih on 2020/8/22.
//

import Networking
import NetworkingTestHelpers
import RxSwift
import XCTest

final class HTTPClientTests: XCTestCase {
    private let bag = DisposeBag()
    
    override func tearDown() {
        TestsURLProtocol.clearMockResponses()
    }
    
    func testFetchDataSuccess() throws {
        let url = URL(string: "https://www.ios.test/")!
        let testData = "test data".data(using: .utf8)!

        try TestsURLProtocol.addMockHTTPResponse(testData, for: url)
        let request = URLRequest(url: url)
        let testSession = URLSession.createTestingSession()
        let testClient = HTTPClient(session: testSession)
        
        let fetchExpectation = expectation(description: "Fetch data")
        
        testClient.fetchData(request: request).subscribe(
            onNext: { XCTAssertEqual(testData, $0) },
            onError: { _ in
                XCTFail("Should not be failed.")
                fetchExpectation.fulfill()
            },
            onCompleted: { fetchExpectation.fulfill() }
        ).disposed(by: bag)
        waitForExpectations(timeout: 0.5)
    }
    
    func testFetchDataFailed() throws {
        let url = URL(string: "https://www.ios.test/")!

        TestsURLProtocol.addMockFailedResponse(error: MockNetworkError.connectionIsBroken, for: url)
        let request = URLRequest(url: url)
        let testSession = URLSession.createTestingSession()
        let testClient = HTTPClient(session: testSession)
        
        let fetchExpectation = expectation(description: "Fetch data")
        
        testClient.fetchData(request: request).subscribe(
            onNext: { _ in
                XCTFail("Should be failed.")
                fetchExpectation.fulfill()
            },
            onError: { error in
                switch error {
                case MockNetworkError.connectionIsBroken:
                    fetchExpectation.fulfill()
                default:
                    XCTFail("Wrong error occur")
                    fetchExpectation.fulfill()
                }
            }
        ).disposed(by: bag)
        waitForExpectations(timeout: 0.5)
    }
    
    func testFetchDataEmptyResponseError() throws {
        let url = URL(string: "https://www.ios.test/")!

        try TestsURLProtocol.addMockHTTPResponse(nil, for: url)
        let request = URLRequest(url: url)
        let testSession = URLSession.createTestingSession()
        let testClient = HTTPClient(session: testSession)
        
        let fetchExpectation = expectation(description: "Fetch data")
        
        testClient.fetchData(request: request).subscribe(
            onNext: { _ in
                XCTFail("Should be failed.")
                fetchExpectation.fulfill()
            },
            onError: { error in
                switch error {
                case HTTPClient.Error.emptyResponse:
                    fetchExpectation.fulfill()
                default:
                    XCTFail("Wrong error occur")
                    fetchExpectation.fulfill()
                }
            }
        ).disposed(by: bag)
        waitForExpectations(timeout: 0.5)
    }
    
    func testFetchDataModelSuccess() throws {
        let url = URL(string: "https://www.ios.test/")!
        let testModel = TestDataModel()
        
        try TestsURLProtocol.addMockHTTPResponse(encoding: testModel, for: url)
        let testSession = URLSession.createTestingSession()
        let testClient = HTTPClient(session: testSession)
        let testRequest = TestRequest<TestDataModel>(baseURL: url)
        
        let fetchExpectation = expectation(description: "Fetch data")
        
        testClient.fetchDataModel(request: testRequest).subscribe(
            onNext: { XCTAssertEqual(testModel, $0) },
            onError: { error in
                XCTFail("Should not be failed.")
                fetchExpectation.fulfill()
            },
            onCompleted: { fetchExpectation.fulfill() }
        ).disposed(by: bag)
        waitForExpectations(timeout: 1)
    }
    
    func testFetchDataModelFailed() throws {
        let url = URL(string: "https://www.ios.test/")!

        TestsURLProtocol.addMockFailedResponse(error: MockNetworkError.connectionIsBroken, for: url)
        let testSession = URLSession.createTestingSession()
        let testClient = HTTPClient(session: testSession)
        let testRequest = TestRequest<TestDataModel>(baseURL: url)
        
        let fetchExpectation = expectation(description: "Fetch data")
        
        testClient.fetchDataModel(request: testRequest).subscribe(
            onNext: { _ in
                XCTFail("Should be failed.")
                fetchExpectation.fulfill()
            },
            onError: { error in
                switch error {
                case MockNetworkError.connectionIsBroken:
                    fetchExpectation.fulfill()
                default:
                    XCTFail("Wrong error occur")
                    fetchExpectation.fulfill()
                }
            }
        ).disposed(by: bag)
        waitForExpectations(timeout: 1)
    }
    
    func testFetchDataModelDecodingFailed() throws {
        let url = URL(string: "https://www.ios.test/")!
        let testModel = TestDataModel()
        
        try TestsURLProtocol.addMockHTTPResponse(encoding: testModel, for: url)
        let testSession = URLSession.createTestingSession()
        let testClient = HTTPClient(session: testSession)
        let testRequest = TestRequest<String>(baseURL: url)
        
        let fetchExpectation = expectation(description: "Fetch data")
        
        testClient.fetchDataModel(request: testRequest).subscribe(
            onNext: { _ in
                XCTFail("Should be failed.")
                fetchExpectation.fulfill()
            },
            onError: { error in
                print(error)
                switch error {
                case DecodingError.typeMismatch:
                    fetchExpectation.fulfill()
                default:
                    XCTFail("Wrong error occur")
                    fetchExpectation.fulfill()
                }
            },
            onCompleted: { fetchExpectation.fulfill() }
        ).disposed(by: bag)
        waitForExpectations(timeout: 1)
    }
}

fileprivate struct TestDataModel: Codable, Equatable {
    let des = "test data"
}
