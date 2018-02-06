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
    
    public func responseCodable<T: Collection & Codable>() -> Promise<T> where T.Element: Codable {
        return responseCodable(emptyJSONForTypeOfT: "[]")
    }
    
    public func responseCodable<T: Codable>() -> Promise<T> {
        return responseCodable(emptyJSONForTypeOfT: "{}")
    }
    
    fileprivate func responseCodable<T: Codable>(emptyJSONForTypeOfT: String) -> Promise<T> {
        return Promise { fulfill, reject in
            responseData(queue: nil) { response in
                switch response.result {
                case .success(var data):
                    
                    if data.isEmpty {
                        // Data may be empty (eg. responses with code 204) but it's not valid JSON and we want to try parsing to expected type T anyway.
                        // So based on type of T (object or array) provide smallest JSON to decoder.
                        data = emptyJSONForTypeOfT.data(using: .utf8)!
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        fulfill(try decoder.decode(T.self, from: data))
                    } catch let error {
                        reject(error)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
}

public struct VoidResponse: Codable {}
