//
//  MessageDBModel3.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation
import WCDBSwift

final class MessageDBModel3: TableCodable {
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
    
    // 额外信息
    var extra: [String: String]?
    
    // 给没给子类特有的字段都加上（data方便读写，string便于阅读、给每个子类的属性都增加单独的数据库列，方便条件查找,缺点是繁琐)
    // MediaMessageModel 特有字段
    var fileSize: Int64?
    var fileName: String?
    var url: String?
    // ImageMessageModel 特有字段
    var width: Int?
    var height: Int?
    var thumbFileName: String?
    var thumbUrl: String?
    // VideoMessageModel 特有字段
    var compressed: Bool?
    // CardMessageModel 特有字段
    var cardUid: Int64?
    var cardName: String?
    var cardIcon: String?
    var cardId: String?
    // LocationMessageModel 特有字段
    var lat: Int32?
    var lng: Int32?
    var address: String?
    // NoticeMessageModel 特有字段
    var noticeId: Int64?
    var showNotify: Bool?
    // FileMessageModel 特有字段
    var mimeType: String?
    var localFileName: String?
    // CallMessageModel 特有字段
    var callType: CallType?
    var callStatus: CallStatus?
    var duration: Int?
    var channelName: String?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = MessageDBModel3
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
        case extra
        // MediaMessageModel 特有字段
        case fileSize
        case fileName
        case url
        // ImageMessageModel 特有字段
        case width
        case height
        case thumbFileName
        case thumbUrl
        // VideoMessageModel 特有字段
        case compressed
        // CardMessageModel 特有字段
        case cardUid
        case cardName
        case cardIcon
        case cardId
        // LocationMessageModel 特有字段
        case lat
        case lng
        case address
        // NoticeMessageModel 特有字段
        case noticeId
        case showNotify
        // FileMessageModel 特有字段
        case mimeType
        case localFileName
        // CallMessageModel 特有字段
        case callType
        case callStatus
        case duration
        case channelName
    }
    
    static var tableName: String {
        return "chats3"
    }
}
// MARK: - Model与DBModel的转换
extension MessageModel {
    var dbModel3: MessageDBModel3 {
        let dbModel = MessageDBModel3()
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
        // 子类model-字段 -> db-字段
        encodeSubInfoModel(dbModel)
        
        return dbModel
    }
    
}
extension MessageDBModel3 {
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
        // db-字段 -> 子类model-字段
        model.decodeSubInfoModel(self)
        
        return model
    }
}
