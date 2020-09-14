//
//  ImageDataValidator.swift
//
//  Created by Nixon Shih on 2020/9/13.
//

import CoreImage
import Foundation

/// A validator that manages to validate the data which is image data
internal struct ImageDataValidator: DataValidator {
    func validateData(_ data: Data) -> Bool {
        CIImage(data: data) != nil
    }
}
