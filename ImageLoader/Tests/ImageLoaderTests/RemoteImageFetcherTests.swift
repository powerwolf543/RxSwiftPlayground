//
//  RemoteImageFetcherTests.swift
//
//  Created by Nixon Shih on 2020/9/9.
//

@testable import ImageLoader
import NetworkingTestHelpers
import RxSwift
import XCTest

final class RemoteImageFetcherTests: XCTestCase {
    private let bag = DisposeBag()
    
    override func tearDown() {
        TestsURLProtocol.clearMockResponses()
    }
    
    func testFetchSuccess() throws {
        let url = URL(string: "https://www.ios.test/")!
        let testData = TestImage.imageData
        
        try TestsURLProtocol.addMockHTTPResponse(testData, for: url)
        let testSession = createTestSession()
        let imageFetcher = RemoteImageFetcher(session: testSession)
        
        let fetchExpectation = expectation(description: "Fetch data")
        
        imageFetcher.fetchImage(with: url).subscribe(
            onNext: { XCTAssertEqual(testData, $0) },
            onError: { _ in
                XCTFail("Should not be failed.")
                fetchExpectation.fulfill()
            },
            onCompleted: { fetchExpectation.fulfill() }
        ).disposed(by: bag)
        waitForExpectations(timeout: 0.5)
    }
    
    private func createTestSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [TestsURLProtocol.self]
        return URLSession(configuration: config)
    }
}
