//
//  CallMessageModel.swift
//  StudyWCDB
//
//  Created by flow on 7/18/24.
//

import Foundation
import WCDBSwift

enum CallType: Int {
    case audio      = 0          // 语音
    case video      = 1        // 视频
}

enum CallStatus: Int {
    case none = 0
    case agree = 1 // 同意
    case refuse = 2// 拒绝
    case cancel = 3 // 取消
    case noResp  = 4// 对方忙 或者超时无应答
    case finish  = 5 // 通话完成
}

class CallMessageModel: MessageModel {
    var callType: CallType = .audio
    var callStatus: CallStatus = .none
    var duration: Int = 0
    var channelName: String = ""
    
    // dict\model两种方式只需要一种
    override func encodeSubInfoDict() -> [String: Any] {
        var dict = super.encodeSubInfoDict()
        dict["callType"] = callType.rawValue
        dict["callStatus"] = callStatus.rawValue
        dict["duration"] = duration
        dict["channelName"] = channelName
        return dict
    }
    override func decodeSubInfoDict(_ dict: [String: Any]) {
        super.decodeSubInfoDict(dict)
        if let val = dict["callType"] as? Int {
            callType = CallType(rawValue: val) ?? .audio
        }
        if let val = dict["callStatus"] as? Int {
            callStatus = CallStatus(rawValue: val) ?? .none
        }
        if let val = dict["duration"] as? Int {
            duration = val
        }
        if let val = dict["channelName"] as? String {
            channelName = val
        }
    }
    
    // model -> DB
    override func encodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.encodeSubInfoModel(dbModel)
        dbModel.callType = callType
        dbModel.callStatus = callStatus
        dbModel.duration = duration
        dbModel.channelName = channelName
    }
    // DB -> model
    override func decodeSubInfoModel(_ dbModel: MessageDBModel3) {
        super.decodeSubInfoModel(dbModel)
        self.callType = dbModel.callType ?? .audio
        self.callStatus = dbModel.callStatus ?? .none
        self.duration = dbModel.duration ?? 0
        self.channelName = dbModel.channelName ?? ""
    }
}
// MARK: 自定义枚举字段
// 自定义WCDB没有支持的类型
extension CallType: ColumnCodable {
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
// MARK: 自定义枚举字段
// 自定义WCDB没有支持的类型
extension CallStatus: ColumnCodable {
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
