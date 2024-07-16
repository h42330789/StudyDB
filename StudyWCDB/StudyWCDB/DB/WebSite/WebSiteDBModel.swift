//
//  WebSiteDBModel.swift
//  StudyWCDB
//
//  Created by flow on 7/16/24.
//

import Foundation
import WCDBSwift

final class WebSiteDBModel: TableCodable {
    var id: Int? // id，自增长
    var name: String? // 网站名称
    var url: String? // 网站地址
    var alexa: Int? // 排名
    var country: String? // 国家码
    var extra: [String: String]?
    var marks: [String]?
    
    // 表名
    static var tableName: String {
        return "Websites"
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WebSiteDBModel
        
        // 默认的限制，不对任何字段做特殊限制
//        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        // 对一些字段做特殊限制，比如自增字段，默认值等
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true) // 设置id为主键、自增
            BindColumnConstraint(alexa, defaultTo: LiteralValue(0)) // 设置alexa默认值为0
        }
        
        case id = "identifier" // 使用了其他名词，就数据库表里就使用自定的名称
        case name
        case url
        case alexa
        case country
        case extra
        case marks
        
        // 对数据库字段进行限制，如果没有就默认限制
        
    }
    
//    var isAutoIncrement: Bool = true // 用于定义是否使用自增的方式插入
}
