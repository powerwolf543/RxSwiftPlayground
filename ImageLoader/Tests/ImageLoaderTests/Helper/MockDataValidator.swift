//
//  MockDataValidator.swift
//
//  Created by Nixon Shih on 2020/9/13.
//

import Foundation
@testable import ImageLoader

struct MockDataValidator: DataValidator {
    let result: Bool
    
    func validateData(_ data: Data) -> Bool { result }
}
