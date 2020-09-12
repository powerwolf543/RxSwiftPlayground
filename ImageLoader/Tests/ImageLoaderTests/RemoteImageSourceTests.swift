//
//  RemoteImageSourceTests.swift
//
//  Created by Nixon Shih on 2020/9/9.
//

@testable import ImageLoader
import NetworkingTestHelpers
import RxSwift
import XCTest

final class RemoteImageSourceTests: XCTestCase {
    override func tearDown() {
        TestsURLProtocol.clearMockResponses()
    }
    
    func testFetchSuccess() throws {
        let url = URL(string: "https://www.ios.test/")!
        let testData = TestImage.imageData
        
        try TestsURLProtocol.addMockHTTPResponse(testData, for: url)
        let testSession = URLSession.createTestingSession()
        let imageFetcher = RemoteImageSource(session: testSession)
        
        let fetchExpectation = expectation(description: "Fetch data")
        
        _ = imageFetcher.fetchImage(with: url).subscribe(
            onNext: { XCTAssertEqual(testData, $0) },
            onError: { _ in
                XCTFail("Should not be failed.")
                fetchExpectation.fulfill()
            },
            onCompleted: { fetchExpectation.fulfill() }
        )
        waitForExpectations(timeout: 0.5)
    }
    
    func testConnectionBreak() {
        let url = URL(string: "https://www.ios.test/")!
        
        TestsURLProtocol.addMockFailedResponse(error: MockNetworkError.connectionIsBroken, for: url)
        let testSession = URLSession.createTestingSession()
        let imageFetcher = RemoteImageSource(session: testSession)
        
        let fetchExpectation = expectation(description: "Fetch data")
        
        _ = imageFetcher.fetchImage(with: url).subscribe(
            onNext: { _ in XCTFail("Should be failed.") },
            onError: { error in
                switch error {
                case ImageLoaderError.networkError(let reason):
                    switch reason {
                    case .connection(let connectionError):
                        switch connectionError {
                        case MockNetworkError.connectionIsBroken:
                            fetchExpectation.fulfill()
                        default:
                            XCTFail("Incorrect error of connection.")
                        }
                    default:
                        XCTFail("Incorrect reason")
                    }
                default:
                    XCTFail("Incorrect error type")
                }
            },
            onCompleted: { fetchExpectation.fulfill() }
        )
        waitForExpectations(timeout: 0.5)
    }
    
    func testEmptyResponse() throws {
        let url = URL(string: "https://www.ios.test/")!
        
        try TestsURLProtocol.addMockHTTPResponse(nil, for: url)
        let testSession = URLSession.createTestingSession()
        let imageFetcher = RemoteImageSource(session: testSession)
        
        let fetchExpectation = expectation(description: "Fetch data")
        
        _ = imageFetcher.fetchImage(with: url).subscribe(
            onNext: { _ in XCTFail("Should be failed.") },
            onError: { error in
                switch error {
                case ImageLoaderError.networkError(let reason):
                    switch reason {
                    case .emptyResponse:
                        fetchExpectation.fulfill()
                    default:
                        XCTFail("Incorrect reason")
                    }
                default:
                    XCTFail("Incorrect error type")
                }
            },
            onCompleted: { fetchExpectation.fulfill() }
        )
        waitForExpectations(timeout: 0.5)
    }
    
    func testErrorCaseOfInvalidData() throws {
        let url = URL(string: "https://www.ios.test/")!
        let testData = Data("Invalid Data".utf8)
        
        try TestsURLProtocol.addMockHTTPResponse(testData, for: url)
        let testSession = URLSession.createTestingSession()
        let imageFetcher = RemoteImageSource(session: testSession)
        
        let fetchExpectation = expectation(description: "Fetch data")
        
        _ = imageFetcher.fetchImage(with: url).subscribe(
            onNext: { _ in XCTFail("Should be failed.") },
            onError: { error in
                switch error {
                case ImageLoaderError.networkError(let reason):
                    switch reason {
                    case .invalidData:
                        fetchExpectation.fulfill()
                    default:
                        XCTFail("Incorrect reason")
                    }
                default:
                    XCTFail("Incorrect error type")
                }
            },
            onCompleted: { fetchExpectation.fulfill() }
        )
        waitForExpectations(timeout: 0.5)
    }
}
