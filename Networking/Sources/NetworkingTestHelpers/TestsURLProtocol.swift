//
//  TestsURLProtocol.swift
//
//  Created by Nixon Shih on 2020/8/22.
//

import Foundation

public final class TestsURLProtocol: URLProtocol {
    public typealias ResponseProvider = (_ request: URLRequest) -> Result<(URLResponse?, Data?), Error>

    /// A dictionary of URLs that map to the mock responses.
    private static var testResponses: [URL: ResponseProvider] = [:]

    public static func clearMockResponses() {
        testResponses = [:]
    }

    public static func addResponseProvider(_ responseProvider: @escaping ResponseProvider, for url: URL) {
        testResponses[url] = responseProvider
    }

    public static func addMockResponse(_ response: URLResponse?, body: Data?, for url: URL) {
        testResponses[url] = { _ in .success((response, body)) }
    }

    @discardableResult
    public static func addMockHTTPResponse(_ bodyData: Data?, for url: URL) throws -> HTTPURLResponse {
        let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: "1.1",
            headerFields: nil
        )!

        addMockResponse(httpResponse, body: bodyData, for: url)

        return httpResponse
    }

    public static func addMockHTTPResponse<Body: Encodable>(encoding responseBody: Body, for url: URL) throws {
        let encoder = JSONEncoder()
        let bodyData = try encoder.encode(responseBody)

        try addMockHTTPResponse(bodyData, for: url)
    }

    public static func addMockFailedResponse(error: Error, for url: URL) {
        testResponses[url] = { _ in .failure(error) }
    }

    override public class func canInit(with task: URLSessionTask) -> Bool {
        true
    }

    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override public func startLoading() {
        guard let client = client else { return }

        let requestURL = request.url!
        let requestComponents = URLComponents(url: requestURL, resolvingAgainstBaseURL: true)!

        for (url, responseProvider) in type(of: self).testResponses {
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!

            /// Compare the hashes rather than the URL or the components directly to allow URLs with the same query parameters in different orders to evalute as equal
            guard requestComponents.hashValue == urlComponents.hashValue else { continue }

            let response = responseProvider(request)
            switch response {
            case .success((let urlResponse, let data)):
                urlResponse.map { client.urlProtocol(self, didReceive: $0, cacheStoragePolicy: .notAllowed) }
                data.map { client.urlProtocol(self, didLoad: $0) }
            case .failure(let error):
                client.urlProtocol(self, didFailWithError: error)
            }

            break
        }

        client.urlProtocolDidFinishLoading(self)
    }

    override public func stopLoading() {}
}
