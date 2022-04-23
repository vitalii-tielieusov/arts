//
//  ArrayExtensions.swift
//  Art Objects
//
//  Created by Vitaliy Teleusov on 20.04.2021.
//

import Foundation

extension Array where Element: Equatable {
    public var lastWithIndex: (element: Element, index: Int)? {
        guard
            let lastElement = last,
            let lastIndex = self.lastIndex(where: { $0 == lastElement })
        else { return nil }
        return (element: lastElement, index: lastIndex)
    }
}
