//
//  MessageDBModel2.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation
import WCDBSwift

final class MessageDBModel2: TableCodable {
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
    // 专门用于子类添加额外信息的json的String（data方便读写，string便于阅读、给每个子类的属性都增加单独的数据库列，方便条件查找）
    var subInfo: String?
    // 额外信息
    var extra: [String: String]?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = MessageDBModel2
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
        return "chats2"
    }
}


// MARK: - Model与DBModel的转换
extension MessageModel {
    var dbModel2: MessageDBModel2 {
        let dbModel = MessageDBModel2()
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
        // 子类model-字段 -> [String: Any] -> String
        dbModel.subInfo = encodeSubInfoDict().jsonString()
        
        return dbModel
    }
}
extension MessageDBModel2 {
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
        // String -> [String: Any] -> 子类-字段
        if let subInfoDict = subInfo?.jsonValue() as? [String: Any] {
           model.decodeSubInfoDict(subInfoDict)
        }
        
        return model
    }
}
