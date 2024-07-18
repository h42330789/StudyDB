//
//  MessageModel.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation

// MARK: - 枚举
enum ChatType: Int32 {
    case p2p = 0
    case group = 1
}
enum MessageType: Int32 {
    case text = 0       // 文本消息
    case image = 1      // 图片消息
    case audio = 2     // 语音消息
    case video = 3     // 视频消息
    case location = 4  // 位置消息
    case card  = 5     // 用户名片
    case system = 6    // 系统消息或者状态
    case file = 7      // 文件
    case notice = 8    // 群公告
    case dynamicImage = 9 // gif图
    case call // 电话
}
// MARK: - 引用消息体
final class RefMessage {
    // 引用消息id
    var msgId: Int64?
    // 引用消息内容
    var content: String?
    // 引用消息类型
    var type: MessageType?
    // 引用消息发送者的uid
    var uid: Int64?
    // 引用消息发送者的nickname
    var nickname: String = String()
    
}

// MARK: - 消息体
class MessageModel {
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
    
    // MARK: - 通过类型初始化具体的子类
    static func model(messageType: MessageType?) -> MessageModel {
        let type = messageType ?? .text
        var model: MessageModel!
        switch messageType {
        case .text:
            model = TextMessageModel()
        case .image:
            model = ImageMessageModel()
        case .video:
            model = VideoMessageModel()
        case .card:
            model = CardMessageModel()
        case .location:
            model = LocationMessageModel()
        case .notice:
            model = NoticeMessageModel()
        case .file:
            model = FileMessageModel()
        case .call:
            model = CallMessageModel()
        default:
            model = MessageModel()
        }
        model.messageType = type
        return model
    }
    
    
    // MARK: - dict\model选一种
    // 将具体子类的特殊字段转换为字典  model-字段 -> dict-> DB-data/string
    func encodeSubInfoDict() -> [String: Any] {
        return [:]
    }
    // 将字典转换为具体子类的特殊字段 DB-data/string -> dict -> model-字段
    func decodeSubInfoDict(_ dict: [String: Any]) {
        
    }
    // model-字段 -> DB-字段
    func encodeSubInfoModel(_ dbModel: MessageDBModel3) {
        
    }
    // DB-字段 -> model-字典
    func decodeSubInfoModel(_ dbModel: MessageDBModel3) {
        
    }
    
}
