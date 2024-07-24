//
//  PeopleDBModel.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/24/24.
//

import Foundation
import WCDBSwift

final class PeopleDBModel: TableCodable {
    var name: String? // 字符串-可以直接存DB
    var age: Int? // 整数-可以直接存DB
    var height: Double? // 小数-可以直接存DB
    var isMarried: Bool? // 枚举值-可以直接存DB
    var birthDate: Date?
    var loveBooks: [String]? // 基本类型的组合-可以直接存
    var gender: Gender? // int类型枚举-需要转换才能存
    var loveSport: SportType? // String的枚举-需要转换才能存
    var pet: Pet?// 对象类型-需要转换才能存
    var extraData: Data?// 字典类型[String: Any]-需要转换成Data才能存
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = PeopleDBModel

        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case name
        case age
        case height
        case isMarried
        case birthDate
        case loveBooks
        case gender
        case loveSport
        case pet
        case extraData
    }
    
    static var tableName: String {
        return "peoples"
    }
}

// MARK: - 枚举类型实现ColumnCodable
extension Gender: ColumnCodable {
    static var columnType: ColumnType {
        return .integer32
    }
    init?(with value: Value) {
        self.init(rawValue: value.intValue)
    }
    func archivedValue() -> Value {
        return Value(self.rawValue)
    }
}
extension SportType: ColumnCodable {
    // ===start===由于分类与定义不在同一个文件，需要自定decoder\encoder
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let sportString = try container.decode(String.self)
        switch sportString {
        case "football":
            self = .football
        case "basketball":
            self = .basketball
        default:
            self = .other(sportString)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .football:
            try container.encode("football")
        case .basketball:
            try container.encode("basketball")
        case .other(let val):
            try container.encode(val)
        }
    }
    // ===end===由于分类与定义不在同一个文件，需要自定decoder\encoder
    
    static var columnType: ColumnType {
        return .text
    }
    init?(with value: Value) {
        self.init(rawValue: value.stringValue)
    }
    func archivedValue() -> Value {
        return Value(self.rawValue)
    }
}
// MARK: - 对象类型实现ColumnCodable
extension Pet: ColumnCodable {
    // ** 由于class或struct的定义，与extension不在同一个文件里才需要 -- start **/
    enum CodingKeys: String, CodingKey {
        case name
        case age
        case type
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(type.rawValue, forKey: .type)
    }
    
    init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let age = try container.decode(Int.self, forKey: .age)
        let typeVal = try container.decode(Int.self, forKey: .type)
        guard let type = PetType(rawValue: typeVal) else {
            throw NSError(domain: "type: \(typeVal)", code: 0)
        }
        self.init(name: name, age: age, type: type)
    }
    // ** 由于class或struct的定义，与extension不在同一个文件里才需要 -- end **/
    // 数据库存储的类型
    
    // ** ColumnCodable -- start **/
    static var columnType: ColumnType {
        return .BLOB
    }
    // 从数据库里解析成Model
    init?(with value: Value) {
        let data = value.dataValue
        guard data.count > 0,
              let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        guard let name = jsonDict["name"] as? String else {
            return nil
        }
        guard let age = jsonDict["age"] as? Int else {
            return nil
        }
        guard let typeVal = jsonDict["type"] as? Int,
           let type = Pet.PetType(rawValue: typeVal) else {
            return nil
        }
        self.init(name: name, age: age, type: type)
        // ** ColumnCodable -- end **/
    }

    // Model存入数据库时调用
    func archivedValue() -> Value {
        var jsonDict: [String: Any] = [:]
        jsonDict["name"] = name
        jsonDict["age"] = age
        jsonDict["type"] = type.rawValue
        guard let data = try? JSONSerialization.data(withJSONObject: (jsonDict as NSDictionary), options: []) else {
            return Value(nil)
        }
        return Value(data)
    }
}

