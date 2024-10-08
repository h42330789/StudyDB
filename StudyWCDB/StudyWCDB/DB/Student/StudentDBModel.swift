//
//  StudentDBModel.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/16/24.
//

import Foundation
import WCDBSwift

final class StudentDBModel: TableCodable {
    var id: Int? = nil // 自增id
    var studentId: Int? = nil // 学号
    var name: String? = nil // 名字
    var age: Int? = nil // 年龄
    var classId: Int? = nil // 班级id
    var createTime: Date? = nil // 创建时间
   
    // 定义表字段
    enum CodingKeys: String, CodingTableKey {
        typealias Root = StudentDBModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            // 对数据库字段进行约束，不特殊设置的字段就是默认设置
            // id字段设置成主键，自增长
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
            // studentId字段设置为非空
            BindColumnConstraint(studentId, isNotNull: true)
        }
        
        case id
        case studentId
        case name
        case age
        case classId
        case createTime
    }
    
    // 一般ORM，一个model对应一个table
    static var tableName: String {
        return "Students"
    }
}

