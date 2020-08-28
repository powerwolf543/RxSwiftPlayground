//
//  ImageLoaderError.swift
//
//  Created by Nixon Shih on 2020/8/28.
//

import Foundation

public enum ImageLoaderError: LocalizedError {
    public enum NetworkErrorReason {
        case emptyResponse
        case connection(Error)
        case invalidData
    }
    
    case networkError(reason: NetworkErrorReason)
    case diskStorerError(Error)
    case memoryStorerError
}
