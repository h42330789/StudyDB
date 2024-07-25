//
//  WCDBTool.swift
//  StudyWCDB
//
//  Created by flow on 7/16/24.
//

import Foundation
import WCDBSwift

class WCDBTool {
    static var dbPath = PathTool.documentsDir.appendPath("/xx/xx/xx.db")

}

extension Array where Element == Expression {
    var conditions: Expression? {
        var finalExp: Expression? = nil
        for exp in self {
            if let preExp = finalExp {
                finalExp = preExp && exp
            } else {
                finalExp = exp
            }
        }
        return finalExp
    }
}
