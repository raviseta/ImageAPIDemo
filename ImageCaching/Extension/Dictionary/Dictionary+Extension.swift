//
//  Dictionary+Extension.swift
//  ImageCaching
//
//  Created by Ravi Seta on 16/04/24.
//

import Foundation

extension Dictionary {
    public func convert<T, U>(_ transform: ((key: Key, value: Value)) throws -> (T, U)) rethrows -> [T: U] {
        var dictionary = [T: U]()
        for (key, value) in self {
            let transformed = try transform((key, value))
            dictionary[transformed.0] = transformed.1
        }
        return dictionary
    }
}
