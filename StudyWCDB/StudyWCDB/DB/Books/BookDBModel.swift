//
//  BookDBModel.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/24/24.
//

import Foundation
import WCDBSwift

final class BookDBModel: TableCodable {
    // 1、定义模型里的字段
    var name: String? // 书本平常
    var picUrl: String? // 书本封面地址
    var desc: String? // 书本介绍
    
    // 2、实现CodingKeys、CodingTableKey协议
    enum CodingKeys: String, CodingTableKey {
        // 2.1、指定对象，一定要是当前类
        typealias Root = BookDBModel
        // 2.2、做绑定
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        // 2.3、定义的数据库表里的字段
        
        case name
        case picUrl
        case desc
    }
}
