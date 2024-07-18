//
//  MessageDBModel.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/17/24.
//

import Foundation
import WCDBSwift

final class MessageDBModel: TableCodable {
    // 消息Id，服务端生成的消息唯一号
    var msgId: Int64?
    // 发送方生成的消息唯一号
    var flag: Int64?
    // 聊天类型
    var chatType: ChatType?
    // 消息类型
    var messageType: MessageType?
    // 消息文本
    var content: String?
    // 引用消息
    var refMsg: RefMessage?
    // at的用户Id
    var atUids: [Int64]? = nil
    // at的用户列表
    var atUsers: [AtUser]? = nil
    // 是否at自己
    var atMe: Bool = false // 群聊消息是否被
    // 专门用于子类添加额外信息的json的data（data方便读写，string便于阅读、给每个子类的属性都增加单独的数据库列，方便条件查找）
    // 数据库里是以json数据保存
    var subInfo: Data?
    // 额外信息
    var extra: [String: String]?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = MessageDBModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case msgId
        case flag
        case chatType
        case messageType
        case content
        case refMsg
        case atUids
        case atUsers
        case atMe
        case subInfo
        case extra
    }
    
    static var tableName: String {
        return "chats"
    }
}

// MARK: - Model与DBModel的转换
extension MessageModel {
    var dbModel: MessageDBModel {
        let dbModel = MessageDBModel()
        dbModel.msgId = msgId
        dbModel.flag = flag
        dbModel.chatType = chatType
        dbModel.messageType = messageType
        dbModel.content = content
        dbModel.refMsg = refMsg
        dbModel.atUids = atUids
        dbModel.atUsers = atUsers
        dbModel.atMe = atMe
        dbModel.extra = extra
        // 子类model-字段 -> [String: Any] -> data
        dbModel.subInfo = encodeSubInfoDict().jsonData()
        
        return dbModel
    }
}
extension MessageDBModel {
    var model: MessageModel {
        let model = MessageModel.model(messageType: messageType)
        model.msgId = msgId
        model.flag = flag
        model.chatType = chatType
        model.messageType = messageType
        model.content = content
        model.refMsg = refMsg
        model.atUids = atUids
        model.atUsers = atUsers
        model.atMe = atMe
        model.extra = extra
        // data -> [String: Any] -> 子类model-字段
        if let subInfoDict = subInfo?.jsonValue() as? [String: Any] {
           model.decodeSubInfoDict(subInfoDict)
        }
        
        return model
    }
}


//https://github.com/Tencent/wcdb/wiki/Swift-%e8%87%aa%e5%ae%9a%e4%b9%89%e5%ad%97%e6%ae%b5%e6%98%a0%e5%b0%84%e7%b1%bb%e5%9e%8b
// MARK: - 自定义字段映射类型ColumnCodable
// MARK: 自定义对象字段
extension RefMessage: ColumnCodable {
    // ** 由于class或struct的定义，与extension不在同一个文件里才需要 -- start **/
    enum CodingKeys: String, CodingKey {
        case msgId
        case content
        case type
        case uid
        case nickname
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(msgId, forKey: .msgId)
        try container.encode(content, forKey: .content)
        try container.encode(type, forKey: .type)
        try container.encode(uid, forKey: .uid)
        try container.encode(nickname, forKey: .nickname)
    }
    
    convenience init(from decoder: any Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        msgId = try container.decode(Int64.self, forKey: .msgId)
        content = try container.decode(String.self, forKey: .content)
        type = try container.decode(MessageType.self, forKey: .type)
        uid = try container.decode(Int64.self, forKey: .uid)
        nickname = try container.decode(String.self, forKey: .nickname)
    }
    // ** 由于class或struct的定义，与extension不在同一个文件里才需要 -- end **/
    // 数据库存储的类型
    
    // ** ColumnCodable -- start **/
    static var columnType: ColumnType {
        return .BLOB
    }
    // 从数据库里解析成Model
    convenience init?(with value: Value) {
        let data = value.dataValue
        guard data.count > 0 else {
            return nil
        }
        guard let dictionary = try? JSONDecoder().decode([String: String].self, from: data) else {
            return nil
        }
        self.init()
        if let val = dictionary["msgId"] {
            msgId = Int64(val)
        }
        content = dictionary["content"]
        if let val = dictionary["type"], let int32Val = Int32(val) {
            type = MessageType(rawValue: int32Val)
        }
        if let val = dictionary["uid"] {
            msgId = Int64(val)
        }
        if let val = dictionary["nickname"] {
            nickname = val
        }
        // ** ColumnCodable -- end **/
    }

    // Model存入数据库时调用
    func archivedValue() -> Value {
        var dict: [String: String] = [:]
        if let msgId = msgId {
            dict["msgId"] = String(msgId)
        }
        if let type = type {
            dict["type"] = String(type.rawValue)
        }
        if let content = content {
            dict["content"] = content
        }
        guard let data = try? JSONEncoder().encode(dict) else {
            return Value(nil)
        }
        return Value(data)
    }
}

// MARK: 自定义枚举字段
// 自定义WCDB没有支持的类型
extension ChatType: ColumnCodable {
    static var columnType: ColumnType {
        return .integer32
    }

    init?(with value: Value) {
        self.init(rawValue: value.int32Value)
    }

    func archivedValue() -> Value {
        return Value(self.rawValue)
    }
}
extension MessageType: ColumnCodable {
    static var columnType: ColumnType {
        return .integer32
    }

    init?(with value: Value) {
        self.init(rawValue: value.int32Value)
    }

    func archivedValue() -> Value {
        return Value(self.rawValue)
    }
}
