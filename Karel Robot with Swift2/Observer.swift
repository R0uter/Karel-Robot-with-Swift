//
//  Observer.swift
//  Karel Robot with Swift2
//
//  Created by R0uter on 15/12/5.
//  Copyright © 2015年 R0uter. All rights reserved.
//

import Foundation
class ErrorObserver {
    private var errorStat:Error?
    func setError(e:Error?) {
        errorStat = e
    }
    func getError() ->Error? {
        return errorStat
    }
}