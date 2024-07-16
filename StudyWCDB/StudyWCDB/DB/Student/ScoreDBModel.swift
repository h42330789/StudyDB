//
//  ScoreDBModel.swift
//  StudyWCDB
//
//  Created by flow on 7/16/24.
//

import Foundation
import WCDBSwift

final class ScoreDBModel: TableCodable {
    var identifier: Int? = nil
    var studentId: Int? = nil
    var score: Double? = nil
   
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ScoreDBModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(identifier, isPrimary: true, isAutoIncrement: true)
        }
        
        case identifier
        case studentId
        case score
    }
    
    // 一般ORM，一个model对应一个table
    static var tableName: String {
        return "Score_Table"
    }
}
