//
//  MemberDBModel.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/25/24.
//

import Foundation
import WCDBSwift

final class GroupMemberDBModel: TableCodable {
    // 用户基本信息
    var user: UserInfo? {
        didSet {
            self.isFriend = user?.friendRelation.isFriend
            self.remarkName = user?.friendRelation.remarkName
            self.isOnline = user?.userOnOrOffline.isOnline
        }
    }
    //--start--这些字段的值查询、排序、分组等作用，真实相通的值存到实际的对象中，相当于重复存储了2遍值
    private var isFriend: Bool?
    private var remarkName: String?
    private var isOnline: Bool?
    //--end--这些字段的值专门用于查询、排序、分组等作用，真实相通的值存到实际的对象中，相当于重复存储了2遍值
    // 群ID
    var groupID: Int64?
    // 成员类型
    var type: MemberType?
    
    
    // 表名
    static var tableName: String {
        return "groupMembers"
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = GroupMemberDBModel
        
        // 默认的限制，不对任何字段做特殊限制
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case user
        case groupID
        case type
        case isFriend
        case remarkName
        case isOnline
    }
}

// MARK: - 枚举类型实现ColumnCodable
extension MemberType: ColumnCodable {
    // ===start===由于分类与定义不在同一个文件，需要自定decoder\encoder
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let val = try container.decode(RawValue.self)
        self.init(rawValue: val)!
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
    // ===end===由于分类与定义不在同一个文件，需要自定decoder\encoder
    // ** ColumnCodable -- start **/
    static var columnType: ColumnType {
        return .integer32
    }
    init?(with value: Value) {
        self.init(rawValue: value.intValue)
    }
    func archivedValue() -> Value {
        return Value(self.rawValue)
    }
    // ** ColumnCodable -- end **/
}
extension MemberGender: ColumnCodable {
    // ===start===由于分类与定义不在同一个文件，需要自定decoder\encoder
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let val = try container.decode(RawValue.self)
        self.init(rawValue: val)!
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
    // ===end===由于分类与定义不在同一个文件，需要自定decoder\encoder
    // ** ColumnCodable -- start **/
    static var columnType: ColumnType {
        return .integer32
    }
    init?(with value: Value) {
        self.init(rawValue: value.intValue)
    }
    func archivedValue() -> Value {
        return Value(self.rawValue)
    }
    // ** ColumnCodable -- end **/
}
// MARK: - 对象类型实现ColumnCodable
extension MemberRelation: ColumnJSONCodable {
    // ** 由于class或struct的定义，与extension不在同一个文件里才需要 -- start **/
    enum CodingKeys: String, CodingKey {
        case isFriend
        case remarkName
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isFriend, forKey: .isFriend)
        try container.encode(remarkName, forKey: .remarkName)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isFriend = try container.decode(Bool.self, forKey: .isFriend)
        remarkName = try container.decode(String.self, forKey: .remarkName)
    }
}
extension MemberPet: ColumnJSONCodable {
    
    
    // ** 由于class或struct的定义，与extension不在同一个文件里才需要 -- start **/
    enum CodingKeys: String, CodingKey {
        case name
        case age
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
    }
    
//    init (from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let name = try container.decode(String.self, forKey: .name)
//        let age = try container.decode(Int.self, forKey: .age)
//        self.init()
//    }
}
// MARK: - 对象类型实现ColumnCodable
extension UserOnOrOffLine: ColumnJSONCodable {
    // ** 由于class或struct的定义，与extension不在同一个文件里才需要 -- start **/
    enum CodingKeys: String, CodingKey {
        case uid
        case isOnline
        case onlineOrOfflineTime
        case isShowOnLineStatus
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(isOnline, forKey: .isOnline)
        try container.encode(onlineOrOfflineTime, forKey: .onlineOrOfflineTime)
        try container.encode(isShowOnLineStatus, forKey: .isShowOnLineStatus)
    }
    
    init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(Int64.self, forKey: .uid)
        isOnline = try container.decode(Bool.self, forKey: .isOnline)
        onlineOrOfflineTime = try container.decode(Int64.self, forKey: .onlineOrOfflineTime)
        isShowOnLineStatus = try container.decode(Bool.self, forKey: .isShowOnLineStatus)

    }
    // ** 由于class或struct的定义，与extension不在同一个文件里才需要 -- end **/
    // 数据库存储的类型
}
// MARK: - 对象类型实现ColumnJSONCodable
extension UserInfo: ColumnJSONCodable {
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case pic
        case gender
        case friendRelation
        case userOnOrOffline
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(name, forKey: .name)
        try container.encode(pic, forKey: .pic)
        try container.encode(gender, forKey: .gender)
        try container.encode(friendRelation, forKey: .friendRelation)
        try container.encode(userOnOrOffline, forKey: .userOnOrOffline)
    }
    
    init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(Int64.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        pic = try container.decode(String.self, forKey: .pic)
        gender = try container.decode(MemberGender.self, forKey: .gender)
        friendRelation = try container.decode(MemberRelation.self, forKey: .friendRelation)
        userOnOrOffline = try container.decode(UserOnOrOffLine.self, forKey: .userOnOrOffline)

    }
}

