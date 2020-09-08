//
//  TestRequest.swift
//  
//  Created by Nixon Shih on 2020/8/23.
//

import Foundation
import Networking

struct TestRequest<T>: NetworkRequest where T: Codable {
    typealias Response = T
    
    let baseURL: URL
    let path: String
    let method: HTTPMethod
    
    init(baseURL: URL, path: String = "", method: HTTPMethod = .get) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
    }
}
