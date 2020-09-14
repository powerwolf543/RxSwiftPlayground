//
//  HTTPURLResponse+createSuccessResponse.swift
//
//  Created by Nixon Shih on 2020/9/13.
//

import Foundation

extension HTTPURLResponse {
    public static func createSuccessResponse(with url: URL) -> HTTPURLResponse {
        HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: "1.1",
            headerFields: nil
        )!
    }
}
