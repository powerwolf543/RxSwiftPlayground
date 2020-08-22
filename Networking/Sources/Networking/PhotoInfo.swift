//
//  PhotoInfo.swift
//
//  Created by Nixon Shih on 2020/8/22.
//

import Foundation

public struct PhotoInfo: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, title, url
        case albumID = "albumId"
        case thumbnailURL = "thumbnailUrl"
    }
    
    public let id: Int
    public let albumID: Int
    public let title: String
    public let url: URL
    public let thumbnailURL: URL
}
