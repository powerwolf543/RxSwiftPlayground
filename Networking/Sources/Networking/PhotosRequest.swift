//
//  PhotosRequest.swift
//
//  Created by Nixon Shih on 2020/8/22.
//

import Foundation

public struct PhotosRequest: NetworkRequest {
    public typealias Response = [PhotoInfo]
    
    public var path: String { "photos" }
    public var method: HTTPMethod { .get }
    
    public init() {}
}
