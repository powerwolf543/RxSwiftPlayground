//
//  DataValidator.swift
//
//  Created by Nixon Shih on 2020/9/13.
//

import Foundation

/// A validator that validates the data
protocol DataValidator {
    func validateData(_ data: Data) -> Bool
}
