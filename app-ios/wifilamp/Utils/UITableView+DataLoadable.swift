//
//  UITableView+NibAware.swift
//  wifilamp
//
//  Created by Džindra on 07/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit
import Rswift


protocol DataLoadable {
    associatedtype DataType
    
    func loadData(data: DataType)
}


extension UITableView {

    func dequeueReusableCell<Identifier>(withIdentifier identifier: Identifier, for indexPath: IndexPath, data: Identifier.ReusableType.DataType) -> Identifier.ReusableType?
        where Identifier: ReuseIdentifierType, Identifier.ReusableType: UITableViewCell, Identifier.ReusableType: DataLoadable {
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath).map {
            $0.loadData(data: data)
            return $0
        }
    }

    
}

extension UICollectionView {
    
    func dequeueReusableCell<Identifier>(withReuseIdentifier identifier: Identifier, for indexPath: IndexPath, data: Identifier.ReusableType.DataType) -> Identifier.ReusableType?
        where Identifier: ReuseIdentifierType, Identifier.ReusableType: UICollectionViewCell, Identifier.ReusableType: DataLoadable {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath).map {
            $0.loadData(data: data)
            return $0
        }
    }
    
    
}
