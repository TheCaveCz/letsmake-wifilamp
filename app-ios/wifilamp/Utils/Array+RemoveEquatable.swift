//
//  Array+RemoveEquatable.swift
//  wifilamp
//
//  Created by Jindrich Dolezy on 10/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation


extension Array where Element: Equatable {
    
    @discardableResult mutating func removeFirst(element: Element) -> Bool {
        guard let index = index(of: element) else {
            return false
        }
        remove(at: index)
        return true
    }
    
}


extension Array {
    
    @discardableResult mutating func removeFirst(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        guard let index = try index(where: predicate) else {
            return nil
        }
        let e = self[index]
        remove(at: index)
        return e
    }
    
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
