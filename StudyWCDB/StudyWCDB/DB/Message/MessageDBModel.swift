//
//  MessageDBModel.swift
//  StudyWCDB
//
//  Created by MacBook Pro on 7/17/24.
//

import Foundation
import WCDBSwift

final class MessageDBModel: TableCodable {
    var msgId: Int64?
    var flag: Int64?
    var chatType: ChatType?
    var messageType: MessageType?
    var content: String?
    var refMsg: RefMessage?
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
        case extra
    }
    
    static var tableName: String {
        return "chats"
    }
}
// MARK: - 非标准类型
enum ChatType: Int32 {
    case p2p = 0
    case group = 1
}

enum MessageType: Int32 {
    case text = 0
    case image = 1
    case video = 2
}
final class RefMessage {
    var msgId: Int64?
    var chatType: ChatType?
    var messageType: MessageType?
    var content: String?
}
//https://github.com/Tencent/wcdb/wiki/Swift-%e8%87%aa%e5%ae%9a%e4%b9%89%e5%ad%97%e6%ae%b5%e6%98%a0%e5%b0%84%e7%b1%bb%e5%9e%8b
// MARK: - 自定义字段映射类型ColumnCodable
// MARK: 自定义对象字段
extension RefMessage: ColumnCodable {
    // 数据库存储的类型
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
        if let val = dictionary["chatType"], let int32Val = Int32(val) {
            chatType = ChatType(rawValue: int32Val)
        }
        if let val = dictionary["messageType"], let int32Val = Int32(val) {
            messageType = MessageType(rawValue: int32Val)
        }
        content = dictionary["content"]
    }

    // Model存入数据库时调用
    func archivedValue() -> Value {
        var dict: [String: String] = [:]
        if let msgId = msgId {
            dict["msgId"] = String(msgId)
        }
        if let chatType = chatType {
            dict["chatType"] = String(chatType.rawValue)
        }
        if let messageType = messageType {
            dict["messageType"] = String(messageType.rawValue)
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
// MARK: Dictionary
//final class MyDictionary: ColumnCodable {
//    var dictionary: [String: Any] = [:]
//    static var columnType: ColumnType {
//        return .BLOB
//    }
//
//    convenience init?(with value: Value) {
//        let data = value.dataValue
//        guard data.count > 0 else {
//            return nil
//        }
//        // data -> dict
//        do {
//            // 将 Data 解码为字典
//            if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                self.init()
//                self.dictionary = dict
//            } else {
//                return nil
//            }
//        } catch {
//            return nil
//        }
//    }
//
//    func archivedValue() -> Value {
//        // dict -> data
//        do {
//            // 将字典编码为 Data
//            let data = try JSONSerialization.data(withJSONObject: self.dictionary, options: [])
//            return Value(data)
//        } catch {
//            return Value(nil)
//        }
//    }
//}
