//
//  ImageLoaderTests.swift
//
//  Created by Nixon Shih on 2020/9/12.
//

@testable import ImageLoader
import NetworkingTestHelpers
import RxSwift
import XCTest

final class ImageLoaderTests: XCTestCase {
    override func tearDown() {
        TestsURLProtocol.clearMockResponses()
    }
    
    func testRetrieveFromCache() {
        let url = URL(string: "https://www.ios.test/a.png")!
        let testData = TestImage.imageData
        
        TestsURLProtocol.addResponseProvider({ _ in
            XCTFail("Should retrieve data from cache.")
            return .success((HTTPURLResponse.createSuccessResponse(with: url), testData))
        }, for: url)
        let testSession = URLSession.createTestingSession()
        let remoteImageSource = RemoteImageSource(session: testSession)
        let cacheStorage = MockStorage()
        cacheStorage.map[url] = testData
        let imageLoader = ImageLoader(remoteImageSource: remoteImageSource, cacheStorage: cacheStorage)
        
        let dataSubcriptionExpectation = expectation(description: "Image data subscription")
        _ = imageLoader.retrieveImageData(with: url).subscribe(
            onNext: { data in
                XCTAssertEqual(data, testData)
            },
            onCompleted: {
                dataSubcriptionExpectation.fulfill()
        })
        
        let imageSubcriptionExpectation = expectation(description: "Image subscription")
        _ = imageLoader.retrieveImage(with: url).subscribe(
            onNext: { image in
                XCTAssertNotNil(image)
                XCTAssertEqual(image?.pngData(), testData)
            },
            onCompleted: {
                imageSubcriptionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
    }
    
    func testRetrieveFromInternet() {
        let url = URL(string: "https://www.ios.test/a.png")!
        let testData = TestImage.imageData

        var hasPerform = false
    
        TestsURLProtocol.addResponseProvider({ _ in
            hasPerform = true
            return .success((HTTPURLResponse.createSuccessResponse(with: url), testData))
        }, for: url)
        let testSession = URLSession.createTestingSession()
        let remoteImageSource = RemoteImageSource(session: testSession)
        let cacheStorage = MockStorage()
        let imageLoader = ImageLoader(remoteImageSource: remoteImageSource, cacheStorage: cacheStorage)
        
        let dataSubcriptionExpectation = expectation(description: "Image data subscription")
        _ = imageLoader.retrieveImageData(with: url).subscribe(
            onNext: { data in
                XCTAssertTrue(hasPerform)
                XCTAssertEqual(data, testData)
                XCTAssertEqual(cacheStorage.map[url], testData)
            },
            onCompleted: {
                dataSubcriptionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
    }
    
    func testRetrieveFromInternetFailed() {
        let url = URL(string: "https://www.ios.test/a.png")!

        let mockError = createMockError()
        TestsURLProtocol.addMockFailedResponse(error: mockError, for: url)
        let testSession = URLSession.createTestingSession()
        let remoteImageSource = RemoteImageSource(session: testSession)
        let cacheStorage = MockStorage()
        let imageLoader = ImageLoader(remoteImageSource: remoteImageSource, cacheStorage: cacheStorage)
        
        let dataSubcriptionExpectation = expectation(description: "Image data subscription")
        _ = imageLoader.retrieveImageData(with: url).subscribe(
            onNext: { data in
                XCTFail("Should be failed")
            },
            onError: { error in
                switch error {
                case ImageLoaderError.networkError(let reason):
                    switch reason {
                    case .connection(let connectionError):
                        let nsError = connectionError as NSError
                        XCTAssertEqual(nsError.code, 123456)
                        XCTAssertEqual(nsError.domain, "unit_test.mock_error")
                        dataSubcriptionExpectation.fulfill()
                    default:
                        XCTFail("Unknown reason")
                    }
                default:
                    XCTFail("Unknown error")
                }
        })
        
        waitForExpectations(timeout: 2)
    }

    private func createMockError() -> Error {
        NSError(domain: "unit_test.mock_error", code: 123456, userInfo: nil)
    }
}
