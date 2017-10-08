//
//  UITableView+NibAware.swift
//  wifilamp
//
//  Created by Džindra on 07/10/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import UIKit

protocol NibAware {
    static var nib: UINib { get }
    static var nibIdentifier: String { get }
}

protocol DataLoadable {
    associatedtype DataType
    
    func loadData(data: DataType)
}

extension NibAware {
    static var nibIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: nibIdentifier, bundle: nil)
    }
}

extension UITableView {
    
    func register<T>(nibAware: T.Type) where T: UITableViewCell, T: NibAware {
        self.register(nibAware.nib, forCellReuseIdentifier: nibAware.nibIdentifier)
    }
    
    func dequeue<T>(_ nibAware: T.Type, for ip: IndexPath) -> T? where T: UITableViewCell, T: NibAware {
        return self.dequeueReusableCell(withIdentifier: nibAware.nibIdentifier, for: ip) as? T
    }
    
    func dequeue<T>(_ nibAware: T.Type, for ip: IndexPath, data: T.DataType) -> T? where T: UITableViewCell, T: NibAware, T: DataLoadable {
        return self.dequeue(nibAware, for: ip).map {
            $0.loadData(data: data)
            return $0
        }
    }
    
    
}
