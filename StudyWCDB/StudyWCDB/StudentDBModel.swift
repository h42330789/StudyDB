//
//  StudentDBModel.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/16/24.
//

import Foundation
import WCDBSwift

final class StudentDBModel: TableCodable {
    var identifier: Int? = nil
    var name: String? = nil
    var age: Int? = nil
   
    enum CodingKeys: String, CodingTableKey {
        typealias Root = StudentDBModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case identifier
        case name
        case age
    }
}

final class ScoreDBModel: TableCodable {
    var identifier: Int? = nil
    var studentId: Int? = nil
    var score: Float? = nil
   
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ScoreDBModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case identifier
        case studentId
        case score
    }
}
