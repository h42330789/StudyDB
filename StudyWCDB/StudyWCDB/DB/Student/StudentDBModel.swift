//
//  StudentDBModel.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/16/24.
//

import Foundation
import WCDBSwift

final class StudentDBModel: TableCodable {
    var stuId: Int? = nil
    var name: String? = nil
    var age: Int? = nil
   
    // 定义表字段
    enum CodingKeys: String, CodingTableKey {
        typealias Root = StudentDBModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case stuId
        case name
        case age
    }
    
    // 一般ORM，一个model对应一个table
    static var tableName: String {
        return "Student_Table"
    }
}

