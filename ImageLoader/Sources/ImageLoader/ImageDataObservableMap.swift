//
//  ImageDataObservableMap.swift
//
//  Created by Nixon Shih on 2020/9/12.
//

import Foundation
import RxSwift

/// The thread safe map of image data observable
internal final class ImageDataObservableMap {
    private var observables: [URL: Observable<Data>]
    private let privateQueue: DispatchQueue
    
    internal init() {
        observables = [:]
        privateQueue = DispatchQueue(label: "com.ImageDataObservableMap.privateQueue", attributes: .concurrent)
    }
    
    internal subscript(_ url: URL) -> Observable<Data>? {
        set {
            privateQueue.sync(flags: .barrier) {
                observables[url] = newValue
            }
        }
        get {
            privateQueue.sync {
                observables[url]
            }
        }
    }
}
