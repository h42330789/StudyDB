//
//  PeopleModel.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/24/24.
//

import Foundation

enum Gender: Int {
    case male // 男
    case femal // 女
    case other // 其他
}

enum SportType {
    typealias RawValue = String
    case football // 足球
    case basketball // 篮球
    case other(String) // 其他
    
    init?(rawValue: String) {
        switch rawValue {
        case "football": self = .football
        case "basketball": self = .basketball
        default: self = .other(rawValue)
        }
    }
    
    var rawValue: String {
        switch self {
        case .football: return "football"
        case .basketball: return "basketball"
        case .other(let i): return i
        }
    }
}

struct Pet {
    enum PetType: Int {
        case cat
        case dog
    }
    var name: String
    var age: Int
    var type: PetType
}

// 不直接使用dbmodel作为业务model使用时为了方便一些自定义字段的使用等
// PeopleModel - DBWorker(WCDB) - PeopleDBModel
class PeopleModel {
    var name: String? // 姓名-字符串-可以直接存DB
    var age: Int? // 年龄-整数-可以直接存DB
    var height: Double? // 身高-小数-可以直接存DB
    var isMarried: Bool? // 是否已婚-布尔值-可以直接存DB
    var birthDate: Date? // 时间-可以直接存DB
    var loveBooks: [String]? // 基本类型的组合-可以直接存
    var gender: Gender? // int类型枚举-需要转换才能存
    var loveSport: SportType? // String的枚举-需要转换才能存
    var pet: Pet?// 对象类型-需要转换才能存
    var extra: [String: Any]?// 字典类型-需要转换才能存,由于不能直接存，所以使用另一个计算属性来中转
    var extraData: Data? {
        get {
            if let jsonDict = extra,
                  let data = try? JSONSerialization.data(withJSONObject: (jsonDict as NSDictionary), options: []) {
                return data
            } else {
                return nil
            }
        } set {
            if let data = newValue,
                  let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                extra = jsonDict
            }
        }
    }
}

extension PeopleModel {
    // 业务数据存入数据库时使用
    var dbModel: PeopleDBModel {
        let dbInfo = PeopleDBModel()
        dbInfo.name = name
        dbInfo.age = age
        dbInfo.height = height
        dbInfo.isMarried = isMarried
        dbInfo.birthDate = birthDate
        dbInfo.loveBooks = loveBooks
        dbInfo.gender = gender
        dbInfo.loveSport = loveSport
        dbInfo.pet = pet
        dbInfo.extraData = extraData
        return dbInfo
    }
}
extension PeopleDBModel {
    // 数据库数据库解析成业务数据使用
    var bizModel: PeopleModel {
        let bizModel = PeopleModel()
        bizModel.name = name
        bizModel.age = age
        bizModel.height = height
        bizModel.isMarried = isMarried
        bizModel.birthDate = birthDate
        bizModel.loveBooks = loveBooks
        bizModel.gender = gender
        bizModel.loveSport = loveSport
        bizModel.pet = pet
        bizModel.extraData = extraData
        return bizModel
    }
}
