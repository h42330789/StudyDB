//
//  ClassDBModel.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/21/24.
//

import Foundation
import WCDBSwift

final class ClassDBModel: TableCodable {
    var id: Int? = nil // 自增id
    var className: String? = nil // 课程名称
   
    // 定义表字段
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ClassDBModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            // 对数据库字段进行约束，不特殊设置的字段就是默认设置
            // id字段设置成主键，自增长
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
        }
        
        case id
        case className
    }
    
    // 一般ORM，一个model对应一个table
    static var tableName: String {
        return "Classes"
    }
}

