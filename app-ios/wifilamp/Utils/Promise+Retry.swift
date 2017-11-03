//
//  Promise+Retry.swift
//  wifilamp
//
//  Created by Lukas Machalik on 03/11/2017.
//  Copyright © 2017 The Cave. All rights reserved.
//

import Foundation
import PromiseKit

func retry<T>(times: Int, cooldown: TimeInterval, body: @escaping () -> Promise<T>) -> Promise<T> {
    var retryCounter = 0
    func attempt() -> Promise<T> {
        return body().recover(policy: CatchPolicy.allErrorsExceptCancellation) { error -> Promise<T> in
            retryCounter += 1
            guard retryCounter <= times else {
                throw error
            }
            return after(interval: cooldown).then(execute: attempt)
        }
    }
    return attempt()
}
