//
//  Array+FilterDuplicates.swift
//  wifilamp
//
//  Created by Lukas Machalik on 07/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation

extension Array {
    
    func filterDuplicates(_ areDuplicates: (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
        var results = [Element]()
        
        forEach { (element) in
            let existingElement = results.first(where: { areDuplicates(element, $0) })
            if existingElement == nil {
                results.append(element)
            }
        }
        
        return results
    }
    
}
