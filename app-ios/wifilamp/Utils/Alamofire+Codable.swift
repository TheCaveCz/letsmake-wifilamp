//
//  Alamofire+Codable.swift
//  wifilamp
//
//  Created by Lukas Machalik on 03/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

extension Alamofire.DataRequest {
    // Return a Promise for a Codable
    public func responseCodable<T: Codable>() -> Promise<T> {
        
        return Promise { fulfill, reject in
            responseData(queue: nil) { response in
                switch response.result {
                case .success(let value):
                    let decoder = JSONDecoder()
                    do {
                        fulfill(try decoder.decode(T.self, from: value))
                    } catch let e {
                        reject(e)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
}

struct VoidResponse: Codable {}
