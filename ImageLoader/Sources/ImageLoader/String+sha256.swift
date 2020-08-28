//
//  String+sha256.swift
//
//  Created by Nixon Shih on 2020/8/28.
//

import CryptoKit
import Foundation

extension String {
    internal var sha256: String {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
