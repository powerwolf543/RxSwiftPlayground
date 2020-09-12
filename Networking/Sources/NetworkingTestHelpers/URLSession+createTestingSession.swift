//
//  URLSession+createTestingSession.swift
//  
//  Created by Nixon Shih on 2020/9/13.
//

import Foundation

extension URLSession {
    public static func createTestingSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [TestsURLProtocol.self]
        return URLSession(configuration: config)
    }
}
