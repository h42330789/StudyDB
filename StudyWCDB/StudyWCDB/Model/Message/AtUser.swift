//
//  AtUser.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation
import WCDBSwift

struct AtUser {
    // 用户ID
    var uid: Int64 = 0
    // 昵称
    var nickName: String = String()
    // 好友关系
    var friendRelation: FriendRelation?
}
// 好友关系信息
struct FriendRelation {
  // 是否好友[此用户是否是当前登录用户的好友]
  var bfFriend: Bool = false
    // 好友备注名OR群昵称
  var remarkName: String = String()
}


// MARK: 数组里的对象套对象
extension AtUser: ColumnCodable {
    // ** 由于class或struct的定义，与extension不在同一个文件里才需要 -- start **/
    // 由于在同一个文件里，不需要手动实现
    //enum CodingKeys: String, CodingKey、func encode(to encoder: any Encoder)、init(from decoder: any Decoder) throws {
    // ** 由于class或struct的定义，与extension不在同一个文件里才需要 -- end **/
    // 数据库存储的类型
    static var columnType: ColumnType {
        return .BLOB
    }
    // 从数据库里解析成Model
    init?(with value: Value) {
        let data = value.dataValue
        guard data.count > 0 else {
            return nil
        }
        guard let dictionary = try? JSONDecoder().decode([String: String].self, from: data) else {
            return nil
        }
        self.init()
        if let val = dictionary["uid"] {
            uid = Int64(val) ?? 0
        }
        if let val = dictionary["friendRelation"] {
            friendRelation = FriendRelation(with: Value(val))
        }
        nickName = dictionary["nickName"] ?? ""
        
    }

    // Model存入数据库时调用
    func archivedValue() -> Value {
        var dict: [String: String] = [:]
        dict["uid"] = String(uid)
        dict["nickName"] = nickName
        if let friendRelation = friendRelation {
            dict["friendRelation"] = friendRelation.archivedValue().stringValue
        }
        guard let data = try? JSONEncoder().encode(dict) else {
            return Value(nil)
        }
        return Value(data)
    }
}
extension FriendRelation: ColumnCodable {
    // ** 由于class或struct的定义，与extension不在同一个文件里才需要 -- start **/
    // 由于在同一个文件里，不需要手动实现
    //enum CodingKeys: String, CodingKey、func encode(to encoder: any Encoder)、init(from decoder: any Decoder) throws {
    // ** 由于class或struct的定义，与extension不在同一个文件里才需要 -- end **/
    // 数据库存储的类型
    static var columnType: ColumnType {
        return .text
    }
    // 从数据库里解析成Model
    init?(with value: Value) {
        let data = value.stringValue
        guard data.count > 0 else {
            return nil
        }
        guard let dictionary = data.jsonValue() as? [String: Any] else {
            return nil
        }
        self.init()
        if let val = dictionary["bfFriend"] as? Bool {
            bfFriend = val
        }
        if let val = dictionary["remarkName"] as? String {
            remarkName = val
        }
    }

    // Model存入数据库时调用
    func archivedValue() -> Value {
        var dict: [String: Any] = [:]
        dict["bfFriend"] = bfFriend
        dict["remarkName"] = remarkName
        guard let data = dict.jsonString() else {
            return Value(nil)
        }
        return Value(data)
    }
}
